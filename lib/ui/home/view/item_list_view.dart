// アイテムのリストを表示するクラス
// あとチェックボックスのクラスもここにある

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/item_viewmodel_provider.dart';


// アイテムのリストを表示するクラス
class ItemListView extends ConsumerStatefulWidget{
  const ItemListView({Key? key}) : super(key: key);
  
  @override
  ConsumerState<ItemListView> createState() => _ItemListViewState();
}
class _ItemListViewState extends ConsumerState<ItemListView> {
  // スクロールコントローラー
  final ScrollController _scrollController = ScrollController();
  // アイテムのリスト
  late List<Map<String, dynamic>> itemList;
  
  // スワイプでアイテムを削除する関数
  // 引数: アイテムのid
  Future<void> _dismissItem(int id) async {
    // ViewModelのインスタンスを取得する
    final itemViewModel = await ref.read(itemViewModelProvider.future);
    // ViewModelのメソッドを呼び出して、アイテムを削除する
    await itemViewModel.deleteItem(id);
    // アイテムをリストから削除//? これがないとエラーが起きるけど、なくても書けそうな気がするのだけど。ConsumerWidgetにしてみるか
    itemList.removeWhere((item) => item['id'] == id);
  }
  
  @override
  Widget build(BuildContext context) {
    // アイテムのリストを取得する//? valueによるnullチェックが入る
    itemList = ref.watch(watchAllItemsStreamForViewProvider).value?? [];
    
    return ListView.separated(
      controller: _scrollController,
      itemCount: itemList.length,
      itemBuilder: (context, index){
        return Dismissible(
          key: Key(itemList[index]['id'].toString()), // アイテムのidをキーにする
          direction: DismissDirection.endToStart,     // スワイプの方向(右から左のみにする)
          onDismissed: (direction) => _dismissItem(itemList[index]['id']), // スワイプした時の処理
          background: _itemDismissBackground(),       // スワイプした時に表示する部分
          child: _itemListTile(itemList[index]),      // アイテムのタイル
        );
      },
      separatorBuilder: (context, index) => const Divider(), // 区切り線
    );
  }
  
  // スワイプした時に表示する部分
  Widget _itemDismissBackground(){
    return Container(
      color: Theme.of(context).colorScheme.error,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 10.0),
      child: const Icon(Icons.delete, color: Colors.white, size: 40),
    );
  }
  
  // アイテムのタイル
  // 引数: アイテムのデータ
  Widget _itemListTile(Map<String, dynamic> item) {
    final CheckBoxWidget checkBoxWidget = CheckBoxWidget(item: item); // チェックボックスクラスのインスタンス
    final String title = item['title']; // タイトル 
    return ListTile(
      title: Text(title),       // タイトル
      leading: checkBoxWidget,  // チェックボックス
      subtitle: Text(item['id'].toString()),  //* id(デバッグ用)
    );
  }
}

// チェックボックスのクラス
// 引数: アイテムのデータ
class CheckBoxWidget extends ConsumerStatefulWidget{
  const CheckBoxWidget({
    Key? key,
    required this.item
  }) : super(key: key);
  
  final Map<String, dynamic> item;  // アイテムのデータ
  
  @override
  ConsumerState<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}
class _CheckBoxWidgetState extends ConsumerState<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5, // チェックボックスの拡大率
      child: Checkbox(
        value: widget.item['isDone'],     // チェックボックスの状態
        shape: const CircleBorder(),      // 丸いチェックボックスにする
        side: const BorderSide(width: 1), // 枠線の太さ
        onChanged: (isDone) {
          // アイテムのチェックボックスの状態を更新する
          _updateItemCheckBox(widget.item);
        },
      ),
    );
  }
  
  // アイテムのチェックボックスの状態を更新する関数
  // 引数: アイテムのデータ
  Future<void> _updateItemCheckBox(Map<String, dynamic> item) async {
    final itemViewModel = await ref.watch(itemViewModelProvider.future);
    itemViewModel.updateItem(item['id'], item['title'], item['subtitle'], !item['isDone']);
  }
}


/*
// コンストラクタ
  _ItemListViewState(){
    _initItemListViewState();
  }
  
  // _ItemListViewStateの初期化関数
  Future<void> _initItemListViewState() async{
    // ViewModelのインスタンスを取得する
    _itemViewModel = await ref.read(itemViewModelProvider.future);
    // アイテムのリストを取得する//? valueによるnullチェックが入る
    _itemList = ref.watch(watchAllItemsStreamForViewProvider).value?? [];
  }
  
  // インスタンス
  final ScrollController _scrollController = ScrollController();  // スクロールコントローラー
  late ItemViewModel _itemViewModel;          // ViewModelのインスタンス
  late List<Map<String, dynamic>> _itemList;  // アイテムのリスト
*/