import 'dart:convert';

import 'package:co2app/providers/api_config_provider.dart';
import 'package:co2app/providers/data_provider.dart';
import 'package:co2app/providers/period_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SwappableClient extends http.BaseClient {
  late http.Client current;
  _SwappableClient(this.current);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      current.send(request);

  @override
  void close() {}
}

Map<String, dynamic> _reading({
  required int co2,
  required double temp,
  required int location,
  required DateTime date,
}) {
  return {
    'created_at': date.toIso8601String(),
    'temp': temp,
    'co2': co2,
    'location_id': location,
  };
}

http.Client _fakeApi({
  List<Map<String, dynamic>> series = const [],
  Map<String, dynamic>? latest,
}) {
  return MockClient((request) async {
    if (request.url.path.contains('search')) {
      return http.Response(jsonEncode(series), 200);
    }
    return http.Response(jsonEncode(latest ?? _reading(
      co2: 600,
      temp: 20,
      location: 1,
      date: DateTime(2024, 1, 1, 12, 0),
    )), 200);
  });
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'wasInit': true,
      'apiUrl': 'http://api.test',
      'apiKey': 'secret',
    });
  });

  test('unconfigured API yields an empty dashboard', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [httpClientProvider.overrideWithValue(_fakeApi())],
    );
    addTearDown(container.dispose);

    final dashboard = await container.read(co2DataProvider.future);
    expect(dashboard.series, isEmpty);
  });

  test('fetches the series and latest reading', () async {
    final now = DateTime(2024, 1, 1, 12, 0);
    final container = ProviderContainer(
      overrides: [
        httpClientProvider.overrideWithValue(_fakeApi(
          series: [
            _reading(co2: 600, temp: 20, location: 1, date: now),
            _reading(co2: 700, temp: 21, location: 1,
                date: now.add(const Duration(hours: 1))),
          ],
          latest: _reading(co2: 800, temp: 22, location: 1,
              date: now.add(const Duration(hours: 2))),
        )),
      ],
    );
    addTearDown(container.dispose);

    await container.read(apiConfigNotifierProvider.future);
    final dashboard = await container.read(co2DataProvider.future);
    expect(dashboard.series, hasLength(2));
    expect(dashboard.latest.co2, 800);
  });

  test('refresh refetches the data', () async {
    final now = DateTime(2024, 1, 1, 12, 0);
    final swappable = _SwappableClient(_fakeApi(
        series: [_reading(co2: 600, temp: 20, location: 1, date: now)]));
    final container = ProviderContainer(
      overrides: [
        httpClientProvider.overrideWithValue(swappable),
      ],
    );
    addTearDown(container.dispose);

    await container.read(apiConfigNotifierProvider.future);
    await container.read(co2DataProvider.future);

    swappable.current = _fakeApi(series: [
      _reading(co2: 900, temp: 23, location: 1, date: now),
      _reading(co2: 950, temp: 23, location: 1, date: now),
    ]);
    await container.read(co2DataProvider.notifier).refresh();

    final dashboard = container.read(co2DataProvider).value!;
    expect(dashboard.series, hasLength(2));
    expect(dashboard.series.first.co2, 900);
  });

  test('polling appends the latest reading and keeps the window size',
      () async {
    final now = DateTime(2024, 1, 1, 12, 0);
    final swappable = _SwappableClient(_fakeApi(
      series: [
        _reading(co2: 600, temp: 20, location: 1, date: now),
        _reading(co2: 650, temp: 20, location: 1,
            date: now.add(const Duration(minutes: 30))),
      ],
      latest: _reading(co2: 700, temp: 21, location: 1,
          date: now.add(const Duration(minutes: 60))),
    ));
    final container = ProviderContainer(
      overrides: [
        httpClientProvider.overrideWithValue(swappable),
        pollIntervalProvider.overrideWithValue(
            const Duration(milliseconds: 50)),
      ],
    );
    addTearDown(container.dispose);

    container.listen(co2DataProvider, (_, __) {});
    await container.read(apiConfigNotifierProvider.future);
    await Future<void>.delayed(Duration.zero);
    var dashboard = await container.read(co2DataProvider.future);
    expect(dashboard.series, hasLength(2));

    swappable.current = _fakeApi(
      series: [
        _reading(co2: 600, temp: 20, location: 1, date: now),
        _reading(co2: 650, temp: 20, location: 1,
            date: now.add(const Duration(minutes: 30))),
      ],
      latest: _reading(co2: 750, temp: 21, location: 1,
          date: now.add(const Duration(minutes: 90))),
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));

    dashboard = container.read(co2DataProvider).value!;
    expect(dashboard.series, hasLength(2));
    expect(dashboard.latest.co2, 750);
  });

  test('failed poll keeps the last good data', () async {
    final now = DateTime(2024, 1, 1, 12, 0);
    final swappable = _SwappableClient(_fakeApi(
        series: [_reading(co2: 600, temp: 20, location: 1, date: now)]));
    final container = ProviderContainer(
      overrides: [
        httpClientProvider.overrideWithValue(swappable),
        pollIntervalProvider.overrideWithValue(
            const Duration(milliseconds: 50)),
      ],
    );
    addTearDown(container.dispose);

    container.listen(co2DataProvider, (_, __) {});
    await container.read(apiConfigNotifierProvider.future);
    await Future<void>.delayed(Duration.zero);
    var dashboard = await container.read(co2DataProvider.future);
    expect(dashboard.latest.co2, 600);

    swappable.current = MockClient((_) async => http.Response('boom', 500));
    await Future<void>.delayed(const Duration(milliseconds: 200));

    dashboard = container.read(co2DataProvider).value!;
    expect(dashboard.latest.co2, 600);
  });

  test('period is persisted when changed', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(periodNotifierProvider.future);
    expect(container.read(periodNotifierProvider).value!.period, 1);

    await container.read(periodNotifierProvider.notifier).setPeriod(6);
    expect(container.read(periodNotifierProvider).value!.period, 6);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('period'), 6);
  });
}
