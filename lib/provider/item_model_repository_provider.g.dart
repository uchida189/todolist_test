// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$itemModelRepositoryHash() =>
    r'099671752a120d23f0750ab320eec4e11057240a';

/// See also [itemModelRepository].
@ProviderFor(itemModelRepository)
final itemModelRepositoryProvider =
    FutureProvider<ItemModelRepository>.internal(
  itemModelRepository,
  name: r'itemModelRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemModelRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ItemModelRepositoryRef = FutureProviderRef<ItemModelRepository>;
String _$watchAllItemsStreamHash() =>
    r'72a64054addc7b3e63162001e3128ed082e9f7a6';

/// See also [watchAllItemsStream].
@ProviderFor(watchAllItemsStream)
final watchAllItemsStreamProvider = StreamProvider<List<ItemModel>>.internal(
  watchAllItemsStream,
  name: r'watchAllItemsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchAllItemsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchAllItemsStreamRef = StreamProviderRef<List<ItemModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
