// 完了済みの全てのアイテムを削除するフローティングアクションボタンのクラス

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/item_viewmodel_provider.dart';

// 完了済みの全てのアイテムを削除するフローティングアクションボタンのクラス
class DeleateAllCompletedItemFloatingActionButton extends ConsumerStatefulWidget{
  const DeleateAllCompletedItemFloatingActionButton({Key? key}) : super(key: key);
  
  @override
  ConsumerState<DeleateAllCompletedItemFloatingActionButton> createState() => _DeleateAllCompletedItemFloatingActionButtonState();
}
class _DeleateAllCompletedItemFloatingActionButtonState extends ConsumerState<DeleateAllCompletedItemFloatingActionButton>{
  // 完了済みの全てのアイテムを削除する関数
  Future<void> _deleteAllCompletedItem() async{
    // ViewModelのインスタンスを取得する
    final itemViewModel = await ref.read(itemViewModelProvider.future);
    // ViewModelのメソッドを呼び出して、アイテムを削除する
    itemViewModel.deleteAllCompletedItems();
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // アイテムを追加する時に表示するシートを表示する
      onPressed: _deleteAllCompletedItem,
      //backgroundColor: Theme.of(context).colorScheme.background,
      child: const Icon(Icons.delete),
    );
  }
}