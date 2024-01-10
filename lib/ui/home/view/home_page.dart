// ホーム画面
// itemViewModelと連携する
// データの取得などは全てitemViewModelのメソッドを呼び出す形で行う
// 直接データベースに接続することはしない

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './add_item_bottomappbar.dart';
import './delete_all_completed_item_floatingactionbutton.dart';
import './item_list_view.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  // アイテムのリストのクラスのインスタンス
  final ItemListView _itemListView = const ItemListView();
  // アイテムを追加するボトムナビゲーションバーのクラスのインスタンス
  final AddItemBottomAppBar _addItemBottomAppBar = const AddItemBottomAppBar();
  // 完了済みの全てのアイテムを削除するフローティングアクションボタンのクラスのインスタンス
  final DeleateAllCompletedItemFloatingActionButton _deleateAllCompletedItemFloatingActionButton = const DeleateAllCompletedItemFloatingActionButton();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // アプリバー
      appBar: _appBar(),
      // ボディー
      body: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: _itemListView, // アイテムのリスト
          ),
        ]),
      ),
      // ボトムナビゲーションバー
      bottomNavigationBar: _addItemBottomAppBar,
      // フローティングアクションボタン
      floatingActionButton: _deleateAllCompletedItemFloatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
  
  // アプリバー
  PreferredSizeWidget _appBar()
   => AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: const Text('Flutter Demo Home Page'),
  );
}


  /*
  // アイテムを追加した後にスクロール
  void _scrollAfterAddItem(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent == 0           // スクロールする位置
        ? 0 : _scrollController.position.maxScrollExtent + 80,  // ↑スクロール可能な領域が0(ない)場合は0にする(スクロールしない)。それ以外はスクロールする(最大値だけだと少し足りなかったので+80している)
      duration: const Duration(milliseconds: 500),              // スクロールの時間
      curve: Curves.easeOut,                                    // スクロールの速度
    );
  }
  */
  
  /*
  コンスタンスでViewModelのインスタンスを生成するやり方(FutureBuilderを使う必要が出てきそう)
  メリット: 複数の関数で使う場合に有効
  デメリット: FutureBuilderを使う必要が出てきそう
             一つの関数でしか使わないならその関数内で良い
  _AddItemFloatingActionButtonState(){
    init();
  }
  Future<void> init() async {
    super.initState();
    itemViewModel = await ref.watch(itemViewModelProvider.future);
  }
  */