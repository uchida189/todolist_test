import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import '../model/item/item_model.dart';

part 'isar_provider.g.dart';


// isarデータベースへの接続を提供する関数
// isarデータベースへの接続が完了すると、Isarのインスタンスを返却する
// riverpod_generator(package: riverpod_annotation)を使って、この関数からIsarのプロバイダー(isarProvider)を生成する
// isarProviderはこの関数を呼び出して、Isarのインスタンスを取得する
// isarProviderを使うことで、isarデータベースへの接続を行うことができる
// isarProviderは、lib/provider/isar_provider.g.dartに保存される
@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  // ディレクトリの取得
  final dir = await getApplicationDocumentsDirectory();
  // Isarの初期化(開く/作成)
  final isar = await Isar.open(
    // ItemModelのスキーマを登録する
    [ItemModelSchema],
    directory: dir.path,
  );
  return isar;
}

// keepAlive: trueを指定することで、このプロバイダーが生成したオブジェクトをキャッシュすることで、
// このプロバイダーが生成したオブジェクトを再利用することができる
// q: keepAlive: trueすることで、isarの初期化処理が毎回行われなくなるのか？
// a: はい、isarの初期化処理が毎回行われなくなります。
// q: keepAlive: trueを指定しない場合は、isarの初期化処理が毎回行われるのか？
// a: はい、isarの初期化処理が毎回行われます。

// q: isarを取得したい場合は、どうすれば良い？
// a: isarProviderを使って、isarを取得することができます。
// q: 使い方を教えてください
// a: isarProviderを使って、isarを取得するには、以下のように書きます。
// final isar = await ref.watch(isarProvider.future);
// q: refはIsarRefじゃなくてもOK？
// a: はい、refはIsarRefじゃなくてもOKです。
// q: IsarRefは何？
// a: IsarRefは、isarProviderを生成するためにあるクラスです。


// q: 上記のisar関数は使わない？
// a: はい、isar関数は使いません。
// q: isar関数は何のためにあるの？
// a: isar関数は、isarProviderを生成するためにある関数です。

