// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiConfigNotifierHash() => r'133f2b0ee5328537962febcb08a4d9156d3afc4a';

/// Loads, saves and resets the [ApiConfig] in [SharedPreferences].
///
/// Copied from [ApiConfigNotifier].
@ProviderFor(ApiConfigNotifier)
final apiConfigNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ApiConfigNotifier, ApiConfig>.internal(
  ApiConfigNotifier.new,
  name: r'apiConfigNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiConfigNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApiConfigNotifier = AutoDisposeAsyncNotifier<ApiConfig>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
