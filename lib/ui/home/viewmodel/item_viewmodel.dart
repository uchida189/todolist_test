// to doアイテムのViewModel
//*ViewModelはViewとModelを切り離す(片方ずつ動かせる)

// 仕事1: itemModelRepositoryを経由してデータベースにアクセスする
// 仕事2: View/itemModelRepositoryで使いやすいようにデータを加工する
// 仕事3: 加工したデータをView/itemModelRepositoryに返す/渡す
// home画面ではなく、ToDoアイテムのみに関する操作を行う
// データベース(isar.itemModel)からデータ(ToDoアイテム)を取得し、そのデータをViewで使いやすいように加工する
// 特記1: データベースへのアクセスは、全てitemModelRepositoryのメソッドを呼び出す形で行い、直接データベースにアクセスしない
// 特記2: Viewもデータの取得は全てViewModelのメソッドを呼び出す形で行い、直接データベースにアクセスしない


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/item/item_model_repository.dart';
import '../../../model/item/item_model.dart';
import '../../../provider/item_model_repository_provider.dart';

class ItemViewModel {
  // コンストラクタ
  // 引数: itemModelRepository
  // 引数: ref
  ItemViewModel(this.itemModelRepository, this.ref) : super();
  
  // itemoModelRepositoryのインスタンス
  // データベース(isar.itemModel)の参照は全てitemModelRepositoryのメソッドを呼び出す形で行う
  final ItemModelRepository itemModelRepository;
  
  final Ref ref;  // このViewModelのRef
  
  
  // Viewで使いやすいようにデータを加工した全てのアイテムを監視・取得するストリーム (Viewで呼び出される)
  Stream<List<Map<String, dynamic>>> watchAllItemsStreamForView() async* {
    // データベースから全てのアイテムを監視・取得するストリームを取得する
    Stream<List<ItemModel>> allItemsStream = watchAllItemsStream();
    
    await for(final allItems in allItemsStream) {
      // 取得したデータをViewで使いやすいように加工する
      final convertedAllItems = await convertAllItemsForView(allItems);
      yield convertedAllItems;
    }
  }
  
  // データベースから全てのアイテムを監視・取得するストリームを取得する関数 (データベースへのアクセス)
  Stream<List<ItemModel>> watchAllItemsStream() async* {
    // itemModelRepositoryのメソッドを呼び出して、ストリームを取得する
    //? .valueによるnullが入る
    final List<ItemModel> allItemsStream = ref.watch(watchAllItemsStreamProvider).value?? [];
    yield allItemsStream;
  }
  
  // Modelから取得したデータをViewで使いやすいように加工する関数
  // 引数: Modelから取得したデータ
  Future<List<Map<String, dynamic>>> convertAllItemsForView(List<ItemModel> allItems) async {
    final List<Map<String, dynamic>> convertedAllItems = [];
    for(ItemModel item in allItems){
      // List<ItemModel>型 -> List<Map<String, dynamic>>型
      convertedAllItems.add({
        'id': item.id,
        'title': item.title,
        'subtitle': item.subtitle,
        'isDone': item.isDone,
      });
    }
    return convertedAllItems;
  }
  
  // アイテムを追加する関数 (Viewで呼び出される)
  // 引数: 追加アイテムのタイトル
  // 引数: 追加アイテムのサブタイトル(メモ)
  Future<void> addItem(String title, String subtitle) async {
    // itemModelRepositoryのメソッドを呼び出して、データベースにアイテムを追加する
    await itemModelRepository.addItem(title, subtitle);
  }
  
  // アイテムを削除する関数 (Viewで呼び出される)
  // 引数: 削除対象のID
  Future<void> deleteItem(int id) async {
    // itemModelRepositoryのメソッドを呼び出して、データベースからアイテムを削除する
    await itemModelRepository.deleteItem(id);
  }
  
  // アイテムを更新する関数 (Viewで呼び出される)
  // 引数: 更新対象のID
  // 引数: 更新後のタイトル
  // 引数: 更新後のサブタイトル(メモ)
  // 引数: 更新後のチェックボックスの状態
  Future<void> updateItem(int id, String title, String subtitle, bool isDone) async {
    // itemModelRepositoryのメソッドを呼び出して、データベースのアイテムを更新する
    await itemModelRepository.updateItem(id, title, subtitle, isDone);
  }
  
}

