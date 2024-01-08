import 'package:riverpod_annotation/riverpod_annotation.dart';

import './isar_provider.dart';
import '../model/item/item_model_repository.dart';
import '../model/item/item_model.dart';

part 'item_model_repository_provider.g.dart';

// ItemModelRepositoryのインスタンスを生成する関数
// riverpod_generatorを使って、ItemModelRepositoryのプロバイダー(itemModelRepositoryProvider)を生成する
// 生成されたプロバイダーは、lib/provider/item_model_repository_provider.g.dartに保存される
@Riverpod(keepAlive: true)
Future<ItemModelRepository> itemModelRepository(ItemModelRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return ItemModelRepository(isar);
}

// 全てのアイテムを監視・取得するストリームを生成する関数
// riverpod_generatorを使って、プロバイダー(watchAllItemsProvider)を生成する
// 生成されたプロバイダーは、lib/provider/item_model_repository_provider.g.dartに保存される
// 別にこれ作る必要は特にない
@Riverpod(keepAlive: true)
Stream<List<ItemModel>> watchAllItemsStream(WatchAllItemsStreamRef ref) async* {
  final itemModelRepository = await ref.watch(itemModelRepositoryProvider.future);
  yield* itemModelRepository.watchAllItemsStream();
}