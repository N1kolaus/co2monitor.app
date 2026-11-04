import 'package:co2app/providers/data_provider.dart';
import 'package:co2app/providers/theme_provider.dart';
import 'package:co2app/screens/line_chart_screen.dart';
import 'package:co2app/snackbars.dart';
import 'package:co2app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main dashboard: the CO2/temperature charts with period selection in the
/// drawer, a refresh button and a theme toggle.
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  Future<void> _onRefresh(BuildContext context, WidgetRef ref) async {
    showLoadingSnackBar(context);
    try {
      await ref.read(co2DataProvider.notifier).refresh();
    } catch (err) {
      if (!context.mounted) return;
      showErrorSnackBar(context, "Data could not be loaded.\n$err");
      return;
    }
    if (context.mounted) {
      showSuccessSnackBar(context, "Data successfully refreshed");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProv = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CO2Monitor'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _onRefresh(context, ref);
            },
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          themeProv.when(
            data: (theme) => IconButton(
              onPressed: () {
                ref
                    .read(themeNotifierProvider.notifier)
                    .setTheme(!theme.isDark);
              },
              icon: theme.isDark
                  ? Icon(
                      Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            ),
            error: (err, _) => Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.primary,
            ),
            loading: () => CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const LineChartScreen(),
    );
  }
}
