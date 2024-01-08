// To DOアイテムのデータモデル
// To DoアイテムのデータモデルはIsarで管理する

import 'package:isar/isar.dart';

part 'item_model.g.dart';

// アイテムのデータモデル
@collection
class ItemModel {
  Id id = Isar.autoIncrement; // ID(自動増分)
  
  String? title;    // タイトル
  String? subtitle; // サブタイトル(メモ)
  bool? isDone;     // チェックボックスの状態
  
  // コンストラクタ
  ItemModel({
    this.title,
    this.subtitle,
    this.isDone = false,  // チェックボックスは未完了で追加する
  });
}
// @Index()を付けるとそれを元に整列される(&検索が高速化される)

// q: データモデルはデータの構成を指す？
// a: はい、データモデルはデータの構成を指します。
// q: データ単体のことはデータモデルとは呼ばない？
// a: はい、データ単体のことはデータモデルとは呼びません。
// q: データ単体のことは何という？
// a: データ単体のことはデータと呼びます。