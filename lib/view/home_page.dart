import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //List<String> items = List<String>.generate(1, (index) => 'Item $index');
  
  // アイテムのリスト
  List<Map<String, dynamic>> items = [{
    'index': 0,               // インデックス
    'isDone': false,          // チェックボックスの状態
    'title': 'item 0',        // タイトル
    'subtitle': 'subtitle0',  // サブタイトル(メモ)
  }];
  
  final ScrollController _scrollController = ScrollController();  // スクロールコントローラー
  
  // アイテムを追加する
  void _addItem() {
    String title = 'item ${items.isEmpty ? 0 : items.last['index'] + 1}';
    String subtitle = 'subtitle${items.isEmpty ? 0 : items.last['index'] + 1}';
    showModalBottomSheet(context: context,
      builder: (context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              const Text('追加するアイテムの情報を入力してください'),
              TextField(
                controller: TextEditingController(text: title),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'タイトル',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: subtitle),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'サブタイトル(メモ)',
                ),
                onChanged: (value) {
                  subtitle = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addItem2(title, subtitle);
                },
                child: const Text('追加'),
              ),
            ],
          ),
        );
      },
    );
  }
  void _addItem2(String title, String subtitle){
    setState(() {
      // アイテムを追加するコード
      items.add({
        'index': items.isEmpty ? 0 : items.last['index'] + 1, // インデックス //?なぜか正常に動くけど大丈夫かこれ？いや番号ダブってるわ
        'isDone': false,                        // チェックボックスの状態
        'title': title,        // タイトル
        'subtitle': subtitle,  // サブタイトル(メモ)
      });
      // アイテムを追加した後にスクロール
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent == 0
          ? 0 : _scrollController.position.maxScrollExtent + 80, // スクロール可能な領域が0(ない)場合は0にする(スクロールしない)。それ以外はスクロールする(最大値だけだと少し足りなかったので+80している)
        duration: const Duration(milliseconds: 500),  // スクロールの時間
        curve: Curves.easeOut,  // スクロールの速度
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: ListView.separated(
              controller: _scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[index]['index'].toString()),
                  onDismissed: (direction) => setState(() => items.removeAt(index)),  // スワイプでアイテムを削除する
                  background: Container(  // スワイプした時に表示する部分
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 10.0),
                    child: const Icon(Icons.delete, color: Colors.white, size: 40),
                  ),
                  direction: DismissDirection.endToStart, // スワイプの方向(右から左のみにする)
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // タイルの区切り線を消す
                    // アイテム
                    child: ExpansionTile(
                      title: Text(items[index]['title']), // タイトル
                      leading: Checkbox(  // チェックボックス
                        value: items[index]['isDone'],
                        onChanged: (value) {
                          setState(() {
                            items[index]['isDone'] = value;
                          });
                        },
                      ),
                      //trailing: const Icon(Icons.arrow_forward_ios),  // 右側のアイコン
                      onExpansionChanged: (bool value) {  // アイテムを開いた時にスクロールする(未完成)
                        if(index == items.length - 1){
                          if (value) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent == 0
                                ? 0 : _scrollController.position.maxScrollExtent + 80,  // スクロールする位置
                              duration: const Duration(milliseconds: 500),  // スクロールの時間
                              curve: Curves.easeOut,  // スクロールの速度
                            );
                          }
                        }
                      },
                      children: [
                        Text(items[index]['subtitle']), // サブタイトル(メモ)
                        Text('index = ${items[index]['index']}'),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      )
    );
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