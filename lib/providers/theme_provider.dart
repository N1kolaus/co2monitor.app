import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';
part 'theme_provider.freezed.dart';

/// SharedPreferences key for the theme preference (kept from the previous
/// implementation so existing installations keep their choice).
const String prefKey = 'co2DarkMode';

/// The app theme.
@freezed
class MyTheme with _$MyTheme {
  factory MyTheme({
    required bool isDark,
  }) = _MyTheme;
}

/// Loads, holds and persists the app theme.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  Future<MyTheme> build() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(prefKey)) {
      await prefs.setBool(prefKey, false);
    }
    return MyTheme(isDark: prefs.getBool(prefKey) ?? false);
  }

  /// Switches between the light and the dark theme and persists the choice.
  Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKey, isDark);
    state = AsyncData(MyTheme(isDark: isDark));
  }
}
