import 'package:co2app/components/color_schemes.dart';
import 'package:co2app/providers/api_config_provider.dart';
import 'package:co2app/providers/theme_provider.dart';
import 'package:co2app/screens/co2_main_screen.dart';
import 'package:co2app/screens/init_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: Co2App(),
    ),
  );
}

/// Root widget: a single [MaterialApp] that shows either the setup screen
/// or the main dashboard, depending on the saved API configuration.
class Co2App extends ConsumerWidget {
  const Co2App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(apiConfigNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CO2Monitor",
      theme: _themeFor(config, ref),
      home: switch (config) {
        AsyncData() => config.value.initialized
            ? const MainScreen()
            : const InitScreen(),
        AsyncError() => const InitScreen(),
        _ => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 40,
            ),
          ),
      },
    );
  }

  /// The setup screen always uses the dark theme, the dashboard follows the
  /// theme chosen by the user.
  ThemeData _themeFor(AsyncValue<ApiConfig> config, WidgetRef ref) {
    final isInitialized = config.valueOrNull?.initialized ?? false;
    if (!isInitialized) {
      return ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    }
    return ref.watch(themeNotifierProvider).when(
          data: (theme) => theme.isDark
              ? ThemeData(useMaterial3: true, colorScheme: darkColorScheme)
              : ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          error: (err, _) =>
              ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          loading: () =>
              ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        );
  }
}
