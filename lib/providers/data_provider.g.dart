// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$co2DataHash() => r'68c0c020cd90180d62fd7e8f119ab8aab401ed93';

/// The dashboard data: the readings for the selected period plus the most
/// recent reading, kept up to date by a background poll every minute.
///
/// Copied from [Co2Data].
@ProviderFor(Co2Data)
final co2DataProvider =
    AutoDisposeAsyncNotifierProvider<Co2Data, Co2Dashboard>.internal(
  Co2Data.new,
  name: r'co2DataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$co2DataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Co2Data = AutoDisposeAsyncNotifier<Co2Dashboard>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
