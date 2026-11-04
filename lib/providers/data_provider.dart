import 'dart:async';

import 'package:co2app/models/co2_data.dart';
import 'package:co2app/providers/api_config_provider.dart';
import 'package:co2app/providers/period_provider.dart';
import 'package:co2app/services/co2_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_provider.g.dart';

/// Shared HTTP client for the CO2 API. Overridden with a fake in tests.
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

/// How often the latest reading is polled while the dashboard is active.
/// Overridden in tests.
final pollIntervalProvider =
    Provider<Duration>((ref) => const Duration(minutes: 1));

/// The dashboard data: the readings for the selected period plus the most
/// recent reading, kept up to date by a background poll every minute.
@riverpod
class Co2Data extends _$Co2Data {
  Timer? _timer;

  @override
  Future<Co2Dashboard> build() async {
    _timer?.cancel();
    final config = ref.watch(apiConfigNotifierProvider).valueOrNull;
    final period = ref.watch(
      periodNotifierProvider.select(
        (state) => state.value?.period ?? 1,
      ),
    );
    final api = _client(config);
    if (api == null) {
      return Co2Dashboard(series: const [], latest: Co2Reading.placeholder());
    }
    _startPolling();
    return _fetch(api, period);
  }

  /// Re-fetches the series and the latest reading (pull-to-refresh).
  /// On failure the last good data is kept and the error is rethrown so
  /// the caller can surface it to the user.
  Future<void> refresh() async {
    final config =
        ref.read(apiConfigNotifierProvider).valueOrNull;
    final period = ref
        .read(periodNotifierProvider.select((state) => state.value?.period ?? 1));
    final api = _client(config);
    if (api == null) {
      state = AsyncData(
          Co2Dashboard(series: const [], latest: Co2Reading.placeholder()));
      return;
    }
    try {
      state = AsyncData(await _fetch(api, period));
    } catch (error, stackTrace) {
      // Keep the last good data; the caller surfaces the error to the user.
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Co2ApiClient? _client(ApiConfig? config) {
    if (config == null || !config.isConfigured) {
      return null;
    }
    return Co2ApiClient(
      client: ref.read(httpClientProvider),
      baseUrl: config.apiUrl,
      apiKey: config.apiKey,
    );
  }

  Future<Co2Dashboard> _fetch(Co2ApiClient api, int period) async {
    final series = await api.fetchRange(period);
    final latest = await api.fetchLatest();
    return Co2Dashboard(series: series, latest: latest);
  }

  void _startPolling() {
    _timer = Timer.periodic(ref.read(pollIntervalProvider), (_) {
      unawaited(_poll());
    });
    ref.onDispose(() => _timer?.cancel());
  }

  /// Appends the newest reading to the series, dropping the oldest one to
  /// keep the window size stable. A failed poll keeps the last good data.
  Future<void> _poll() async {
    try {
      final config = ref.read(apiConfigNotifierProvider).valueOrNull;
      final api = _client(config);
      if (api == null) return;
      final latest = await api.fetchLatest();
      final current = state.valueOrNull;
      if (current == null) return;
      final series = current.series;
      state = AsyncData(Co2Dashboard(
        series: [...series.skip(1), latest],
        latest: latest,
      ));
    } catch (_) {
      // Ignore: the next poll retries and the UI keeps the last good data.
    }
  }
}
