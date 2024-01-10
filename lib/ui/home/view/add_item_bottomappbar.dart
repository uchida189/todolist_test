// ホーム画面に表示するアイテムを追加するボトムアプリバーのクラス

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/item_viewmodel_provider.dart';

// アイテムを追加するボトムアプリバーのクラス
class AddItemBottomAppBar extends ConsumerStatefulWidget{
  const AddItemBottomAppBar({Key? key}) : super(key: key);
  
  @override
  ConsumerState<AddItemBottomAppBar> createState() => _AddItemBottomAppBarState();
}
class _AddItemBottomAppBarState extends ConsumerState<AddItemBottomAppBar>{
  // 追加するアイテムのタイトルを入力するテキストフィールドのコントローラー
  final _addItemTitleController = TextEditingController();
  
  // アイテムを追加するボタンを押した時の処理
  void _doneAddItemButton() async{
    // ViewModelのインスタンスを取得する
    final itemViewModel = await ref.read(itemViewModelProvider.future);
    // ViewModelのメソッドを呼び出して、アイテムを追加する
    itemViewModel.addItem(_addItemTitleController.text, '');
    // テキストフィールドの値を初期化して、キーボードを閉じる
    _addItemTitleController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      // キーボードが表示されている時に、キーボードの上に表示する
      //* これじゃなくてやっぱりsingleChildScrollView使おう。
      offset: Offset(0, -1*MediaQuery.of(context).viewInsets.bottom),
      child: BottomAppBar(
        padding: const EdgeInsets.only(left: 10),
        child: Row(children: <Widget>[
          // 入力スペース
          Expanded(
            child: _addItemTitleTextField(),
          ),
          // アイテムを追加するボタン
          _addItemButton(),
        ])
      ),
    );
  }
  
  // 追加するアイテムのタイトルを入力するテキストフィールド
  Widget _addItemTitleTextField(){
    return TextField(
      controller: _addItemTitleController,  // コントローラーを設定する
      maxLines: 3,      // 最大行数
      minLines: 1,      // 最小行数
      decoration: const InputDecoration(
        hintText: 'やること',           // ヒントテキスト
        border: OutlineInputBorder(),  // 枠線を表示する
        contentPadding: EdgeInsets.only(right: 12, left: 12), // 入力スペースの内側のスペース
      ),
      onChanged: (value) {
        // 入力でテキストフィールドの値を更新する
        _addItemTitleController.text = value;
      },
      onTapOutside: (event) {
        // 画面外タップでキーボードを閉じる
        FocusScope.of(context).unfocus();
      },
    );
  }
  
  // アイテムを追加するボタン
  Widget _addItemButton(){
    return FilledButton(
      onPressed: () => _doneAddItemButton(),
      style: FilledButton.styleFrom(shape: const CircleBorder(), padding: EdgeInsets.zero),
      child: const Icon(Icons.send),
    );
  }
}