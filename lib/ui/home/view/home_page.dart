// ホーム画面
// itemViewModelと連携する
// データの取得などは全てitemViewModelのメソッドを呼び出す形で行う
// 直接データベースに接続することはしない

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/item_viewmodel.dart';
import '../../../provider/item_viewmodel_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final ItemListWidget _itemListWidget = const ItemListWidget();    // アイテムのリストのクラスのインスタンス
  
  final ScrollController _scrollController = ScrollController();  // スクロールコントローラー
  
  // アイテムを追加する用のシートを表示する
  void _showAddItemBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _addItemBottomSheet() // シートを表示する(機能的凝集？・メッセージ結合)
    );
  }
  // アイテムを追加するボタンを押した時の処理
  void _doneAddItemButton(String title, String subtitle){
    setState(() {
      //itemViewModel.addItem(title, subtitle);  // ViewModelでアイテムを追加する
      _scrollAfterAddItem();     // アイテムを追加した後にスクロール
    });
  }
  // アイテムを追加した後にスクロール
  void _scrollAfterAddItem(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent == 0           // スクロールする位置
        ? 0 : _scrollController.position.maxScrollExtent + 80,  // ↑スクロール可能な領域が0(ない)場合は0にする(スクロールしない)。それ以外はスクロールする(最大値だけだと少し足りなかったので+80している)
      duration: const Duration(milliseconds: 500),              // スクロールの時間
      curve: Curves.easeOut,                                    // スクロールの速度
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // アプリバー
      appBar: _appBar(),
      // ボディー
      body: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: _itemListWidget, // アイテムのリスト
          ),
        ]),
      ),
      // フローティングアクションボタン
      floatingActionButton: _addItemFloatingActionButton(),
      // ボトムナビゲーションバー
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
  
  // アプリバー
  PreferredSizeWidget _appBar()
   => AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: const Text('Flutter Demo Home Page'),
  );
  
  // アイテムを追加するフローティングアクションボタン
  Widget _addItemFloatingActionButton()
   => FloatingActionButton(
    // アイテムを追加する時に表示するシートを表示する
    onPressed: _showAddItemBottomSheet,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
  );
  
  // アイテムを追加する時に表示するシート
  //? こういうのはpageにしよう
  Widget _addItemBottomSheet(){
    return SizedBox(
      height: 400,
      child: Column(children: [
        const Text('追加するアイテムの情報を入力してください'),
        _addItemTitleTextField(),     // タイトルを入力するテキストフィールド(メッセージ結合)
        _addItemSubtitleTextField(),  // サブタイトル(メモ)を入力するテキストフィールド(メッセージ結合)
        _addItemButton(),             // アイテムを追加するボタン(メッセージ結合)
      ]),
    );
  }
  
  // 追加するアイテムのタイトルを入力するテキストフィールド
  Widget _addItemTitleTextField(){
    String title = '新規';       // タイトルの初期値
    return TextField(
      controller: TextEditingController(text: title), // 初期値を設定
      decoration: const InputDecoration(border: OutlineInputBorder()),  // 枠線を表示する
      onChanged: (value) {
        title = value;
      },
    );
  }
  
  // 追加するアイテムのサブタイトル(メモ)を入力するテキストフィールド
  Widget _addItemSubtitleTextField(){
    String subtitle = '';
    return TextField(
      controller: TextEditingController(text: subtitle),
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (value) {
        subtitle = value;
      },
    );
  }
  
  // アイテムを追加するボタン
  Widget _addItemButton(){
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _doneAddItemButton('新規', '');
      },
      child: const Text('追加'),
    );
  }
  
  // ボトムナビゲーションバー
  Widget _bottomNavigationBar()
   => BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        label: 'Business',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'School',
      ),
    ],
    currentIndex: 0,
    selectedItemColor: Theme.of(context).colorScheme.primary,
    onTap: (index) {},
  );
  
}

// アイテムのリストのクラス
class ItemListWidget extends ConsumerWidget {
  const ItemListWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController();         // スクロールコントローラー
    final futureItemViewModel = ref.watch(itemViewModelProvider.future);  // ViewModelのFutureインスタンスを取得する
    // アイテムのリストを取得する
    //? valueによるnullチェックが入る
    final items = ref.watch(watchAllItemsStreamForViewProvider).value?? [];
    
    return ListView.separated(
      controller: scrollController,
      itemCount: items.length,
      itemBuilder: (context, index)
       => Dismissible(
        key: Key(items[index]['id'].toString()),  // アイテムのidをキーにする
        direction: DismissDirection.endToStart,   // スワイプの方向(右から左のみにする)
        onDismissed: (direction)
         => futureItemViewModel.then((itemViewModel)
           => itemViewModel.deleteItem(items[index]['id'])),  // スワイプでアイテムを削除する
        background: _itemDismissBackground(context),  // スワイプした時に表示する部分
        child: _itemListTile(context, items[index]),  // アイテムのタイル
      ),
      separatorBuilder: (context, index)
       => const Divider(), // 区切り線
    );
  }
  
  // スワイプした時に表示する部分
  Widget _itemDismissBackground(context)
   => Container(
    color: Theme.of(context).colorScheme.error,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 10.0),
    child: const Icon(Icons.delete, color: Colors.white, size: 40),
  );
  
  // アイテムのタイル
  // 引数: アイテムのデータ
  Widget _itemListTile(context, Map<String, dynamic> item){
    final CheckBoxWidget checkBoxWidget = CheckBoxWidget(item: item); // チェックボックスクラスのインスタンス
    final String title = item['title'];       // タイトル 
    final String subtitle = item['subtitle']; // サブタイトル(メモ)
    return Theme(
      // ExpansionTileを展開した時に表示される区切り線を消す
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title),         // タイトル
        leading: checkBoxWidget,    // チェックボックス
        children: [Text(subtitle)], // サブタイトル(メモ)
      ),
    );
  }
  
}

// チェックボックスのクラス
// 引数: アイテムのデータ
class CheckBoxWidget extends ConsumerWidget {
  const CheckBoxWidget({
    Key? key,
    required this.item
  }) : super(key: key);
  
  final Map<String, dynamic> item;  // アイテムのデータ
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelのFutureインスタンスを取得する
    final futureItemViewModel = ref.watch(itemViewModelProvider.future);
    
    return Checkbox(
      // チェックボックスの状態
      value: item['isDone'],
      onChanged: (isDone) {
        // アイテムのチェックボックスの状態を更新する
        _updateItemCheckBox(futureItemViewModel, item);
      },
    );
  }
  
  // アイテムのチェックボックスの状態を更新する関数
  // 引数: ViewModelのFutureインスタンス
  // 引数: アイテムのデータ
  Future<void> _updateItemCheckBox(Future<ItemViewModel> futureItemViewModel, Map<String, dynamic> item) async {
    futureItemViewModel.then((itemViewModel)
        // チェックボックスの状態だけ更新する
     => itemViewModel.updateItem(item['id'], item['title'], item['subtitle'], !item['isDone']));
  }
}

/*
確認のダイアログを表示する
ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Item $index dismissed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => setState(() {
                            //_counter++;
                          }),
                      ),
                    )
                  ),
                  */
  //String title = 'item ${items.isEmpty ? 0 : items.last['index'] + 1}';       // タイトルの初期値
  //String subtitle = 'subtitle${items.isEmpty ? 0 : items.last['index'] + 1}'; // サブタイトル(メモ)の初期値
  /*
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _addItem2(title, subtitle);
          },
          child: const Text('追加'),
        )*/
        
/*
// 追加するアイテムのタイトルを入力するテキストフィールド
  Widget _addItemTitleTextField(){
    String title = '新規';       // タイトルの初期値
    //String title = 'item ${items.isEmpty ? 0 : items.last['index'] + 1}';  // 依存度が高いので保留
    return TextField(
      controller: TextEditingController(text: title),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        //labelText: 'タイトル',
      ),
      onChanged: (value) {
        title = value;
      },
    );
  }
*/