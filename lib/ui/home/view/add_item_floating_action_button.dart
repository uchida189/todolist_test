// ホーム画面に表示するアイテムを追加するフローティングアクションボタンのクラス

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/item_viewmodel_provider.dart';

// アイテムを追加するフローティングアクションボタンのクラス
class AddItemFloatingActionButton extends ConsumerStatefulWidget{
  const AddItemFloatingActionButton({Key? key}) : super(key: key);
  
  @override
  ConsumerState<AddItemFloatingActionButton> createState() => _AddItemFloatingActionButtonState();
}
class _AddItemFloatingActionButtonState extends ConsumerState<AddItemFloatingActionButton>{
  String _addItemTitle = '';       // 追加するアイテムのタイトル
  String _addItemSubtitle = '';    // 追加するアイテムのサブタイトル(メモ)
  
  // アイテムを追加する用のシートを表示する
  void _showAddItemBottomSheet() {
    _addItemTitle = '';       // 追加するアイテムのタイトルを初期化する
    _addItemSubtitle = '';    // 追加するアイテムのタイトルを初期化する
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // シートの高さ上限をなくす
      builder: (context) => _addItemBottomSheet() // シートを表示する
    );
  }
  
  // アイテムを追加するボタンを押した時の処理
  void _doneAddItemButton() async{
    // ViewModelのインスタンスを取得する
    final itemViewModel = await ref.read(itemViewModelProvider.future);
    // ViewModelのメソッドを呼び出して、アイテムを追加する
    itemViewModel.addItem(_addItemTitle, _addItemSubtitle);
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // アイテムを追加する時に表示するシートを表示する
      onPressed: _showAddItemBottomSheet,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
  
  // アイテムを追加する時に表示するシート
  //? こういうのはpageにしよう
  Widget _addItemBottomSheet(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min, // シートの高さを中身の大きさに合わせる
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width*0.75,
                height: 40,
                child: _addItemTitleTextField() // タイトルを入力するテキストフィールド
              ),
              _addItemButton(), // アイテムを追加するボタン
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // キーボードの高さ分の余白
        ]
      ),
    );
  }
  
  // 追加するアイテムのタイトルを入力するテキストフィールド
  Widget _addItemTitleTextField(){
    return TextField(
      autofocus: true,
      textAlignVertical: TextAlignVertical.bottom,
      controller: TextEditingController(text: _addItemTitle),           // 初期値を設定する
      decoration: const InputDecoration(
        hintText: 'やること',
        border: OutlineInputBorder()
      ),  // 枠線を表示する
      onChanged: (value) {
        // タイトルを更新する
        _addItemTitle = value;
      },
    );
  }
  
  // 追加するアイテムのサブタイトル(メモ)を入力するテキストフィールド
  Widget _addItemSubtitleTextField(){
    return TextField(
      controller: TextEditingController(text: _addItemSubtitle),
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (value) {
        // サブタイトル(メモ)を更新する
        _addItemSubtitle = value;
      },
    );
  }
  
  // アイテムを追加するボタン
  Widget _addItemButton(){
    return FilledButton(
      onPressed: () {
        Navigator.of(context).pop();
        _doneAddItemButton();
      },
      child: const Text('追加'),
    );
  }
}