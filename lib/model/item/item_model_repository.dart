// アイテムリポジトリ
// データベースにアクセスして、アイテムを追加・削除・更新・取得する処理を行う
// 仕事1: データベースにアクセスする
// 仕事2: データベースに対する操作を行う（アイテムを追加・削除・更新・取得）
// データベースからのデータの取得は、全てitemModelRepositoryで行う
// つまり、ViewModelでitemModelRepositoryを経由してデータベースにアクセスし、
// データを取得するなどの行為は行わない

// 特記1: データの一覧(全てのアイテム)をStreamで流す
// 特記1.1: データベースの監視にはwatch()メソッドを使う
// 特記1.1.1: ただし場合によってはwatchLazyにするかもしれない

// 参考1: https://zenn.dev/ktakayama/articles/46cd85c1072898

import 'package:isar/isar.dart';
import 'dart:async';

import './item_model.dart';

class ItemModelRepository {
  // コンストラクタ
  ItemModelRepository(this.isar);
  
  final Isar isar;  // Isarインスタンス
  
  
  // 全てのアイテムを監視・取得するストリーム(ViewModelで呼び出される)
  // データに変更があったら、全てのアイテム(変更を反映する)を返す
  Stream<List<ItemModel>> watchAllItemsStream() async* {
    // 全てのアイテムを取得するクエリ(検索条件なし)
    var query = isar.itemModels.where();
    // クエリ結果の変更を監視するStreamを作成する
    var stream = query.watch(fireImmediately: true);
    
    // クエリ結果に変更があったら、全てのアイテムを返す(クエリ結果への変更も反映される)
    await for(final allItems in stream) {
      yield allItems;
    }
  }
  
  // 指定したIDのアイテムを取得する処理(ViewModelで呼び出される)
  // 引数: 取得対象のID
  Future<ItemModel> getItem(int id) async {
    // 指定したIDのアイテムを取得するクエリ
    final query = isar.itemModels.where().idEqualTo(id);
    
    // 指定したIDのアイテムを取得する
    final results = await query.findAll();
    return results.first;
  }
  
  // アイテムを追加する処理(ViewModelで呼び出される)
  // 引数: 追加アイテムのタイトル
  // 引数: 追加アイテムのサブタイトル(メモ)
  Future<void> addItem(String title, String subtitle) async {
    await isar.writeTxn(() async {
      // アイテムを追加する //// チェックボックスは未完了で追加する
      await isar.itemModels.put(
        ItemModel()
          ..title = title
          ..subtitle = subtitle
      );
    });
  }
  
  // アイテムを削除する処理(ViewModelで呼び出される)
  // 引数: 削除対象のID
  Future<void> deleteItem(int id) async {
    await isar.writeTxn(() async {
      // アイテムを削除する
      await isar.itemModels.delete(id);
    });
  }
  
  // 完了済みの全てのアイテムを削除する処理(ViewModelで呼び出される)
  Future<void> deleteAllCompletedItems() async {
    await isar.writeTxn(() async {
      // 完了済みの全てのアイテムを検索するクエリ
      final query = isar.itemModels.filter().isDoneEqualTo(true);
      // 完了済みの全てのアイテムのIDを取得する
      final completedItemsIdList = await query.findAll().then((value) => value.map((e) => e.id).toList());
      
      // 完了済みの全てのアイテムを削除する
      await isar.itemModels.deleteAll(completedItemsIdList);
    });
  }
  
  // アイテムを更新(編集)する処理(ViewModelで呼び出される)
  // 引数: 更新対象のID
  // 引数: 更新後のタイトル
  // 引数: 更新後のサブタイトル(メモ)
  // 引数: 更新後のチェックボックスの状態
  Future<void> updateItem(int id, String title, String subtitle, bool isDone) async {
    await isar.writeTxn(() async {
      // アイテムを更新する
      await isar.itemModels.put(
        ItemModel()
          ..id = id
          ..title = title
          ..subtitle = subtitle
          ..isDone = isDone
      );
    });
  }
  
}

/*
・「ItemModelの変更を監視するStream: itemModelWatcherStream」をwatchLazyで作る
・itemModelWatcherStreamをlistenして、ItemModelに変更があったら、_itemStreamControllerに全アイテムを流す
*/
////if(!isar.isOpen) return;                          // Isarが開かれていない場合は何もしない
      ////if(_itemStreamController.isClosed) return;        // Streamが閉じられている場合は何もしない
      ////print('ItemModelRepository: アイテムの変更を監視する');
      
/*
  // コンストラクタ
  ItemModelRepository(this.isar){ // アイテムの変更を監視する //?一応だけどこれコンストラクタで良いのか？てかコンストラクタでやるにしても切り分けるべきだよね
    isar.itemModels // isar.itemModels.watchLazy()でアイテムの変更を監視するためのStreamを生成する
    .watchLazy()  // itemが変更される度に新しいeventを流す(生成する)
    .listen(      // listen()でこのStreamにリスナー(コレクションが変更されたときに実行するコード)を追加する
      (event) 
      async         // アイテムの変更の監視は非同期で行われる
      {
        // リスナー(コレクションが変更されたときに実行するコード)
        _itemStreamController.sink.add(await getAllItems());    // アイテムの変更(全アイテム)をStreamに流す(追加する)
          // _itemStreamControllerにはawait getAllItems()で取得した全てのアイテムが入っている
      }
    );
  }
*/
/*
・watchLazy()でやる場合
ItemModelRepository(this.isar){
  isar.itemModels.watchLazy().listen((event) async {
    _itemStreamController.sink.add(await getAllItems());
  });
}

・watch()でやる場合
Stream<List<Memo>> watchAllMemos() async* {
    final query = isar.memos.where().sortByUpdated().build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results;
      } else {
        yield [];
      }
    }
  }
*/

/*

    // fireImmediatelyをtrueに設定すると、watch()メソッドを呼び出した直後に現在のデータベースの状態に基づいてイベントが発火する
stream.listen((event) async* {
      // eventには、変更があったアイテムだけでなく全てのクエリ結果が入っている
      yield event;
      //final results = query.findAll();
      //yield results;
    });
*/
/*
  // 全てのアイテムを取得する処理(ViewModelで呼び出される)
  Future<List<ItemModel>> getAllItems() async {
    // 全てのアイテムを取得するクエリ(検索条件なし)
    final query = isar.itemModels.where();
    
    // 全てのアイテムを取得する
    final results = await query.findAll();
    return results;
  }
  */