import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'period_provider.g.dart';
part 'period_provider.freezed.dart';

const _prefKeyPeriod = 'period';

@freezed
class PeriodState with _$PeriodState {
  const factory PeriodState({required int period}) = _PeriodState;
}

@riverpod
class PeriodNotifier extends _$PeriodNotifier {
  @override
  Future<PeriodState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final period = prefs.getInt(_prefKeyPeriod) ?? 1;
    return PeriodState(period: period);
  }

  /// Sets the chart period in hours and persists it.
  Future<void> setPeriod(int period) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyPeriod, period);
    state = AsyncData(PeriodState(period: period));
  }
}
