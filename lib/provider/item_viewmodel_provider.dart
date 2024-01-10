import 'package:riverpod_annotation/riverpod_annotation.dart';

import './item_model_repository_provider.dart';
import '../ui/home/viewmodel/item_viewmodel.dart';

part 'item_viewmodel_provider.g.dart';

// itemVeiewModelのインスタンスを生成する関数
// riverpod_generatorを使って、itemViewModelのプロバイダー(itemViewModelProvider)を生成する
// 生成されたプロバイダーは、lib/provider/item_viewmodel_provider.g.dartに保存される
@Riverpod(keepAlive: true)
Future<ItemViewModel> itemViewModel(ItemViewModelRef ref) async {
  final itemModelRepository = await ref.watch(itemModelRepositoryProvider.future);
  return ItemViewModel(itemModelRepository, ref);
}

// Viewで使いやすいようにデータを加工した全てのアイテムを監視・取得するストリームを生成する関数
// riverpod_generatorを使って、プロバイダー(watchAllItemsStreamForViewProvider)を生成する
//* Isarはx86プラットフォームをサポートしていないらしく、x86のエミュレータで動かすとエラーが出る
@Riverpod(keepAlive: true)
Stream<List<Map<String, dynamic>>> watchAllItemsStreamForView(WatchAllItemsStreamForViewRef ref) async* {
  final itemViewModel = await ref.watch(itemViewModelProvider.future);
  yield* itemViewModel.watchAllItemsStreamForView();
}