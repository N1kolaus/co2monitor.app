import 'package:co2app/providers/api_config_provider.dart';
import 'package:co2app/providers/period_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _periods = [1, 3, 6, 12, 24, 48];

/// Drawer with the time-period selector and the init-state reset.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Future<void> _onPeriodSelected(int period, BuildContext context,
      WidgetRef ref) async {
    await ref.read(periodNotifierProvider.notifier).setPeriod(period);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "Set time period",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: MediaQuery.of(context).size.height * 0.01 * 2,
              ),
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.secondary,
              size: MediaQuery.of(context).size.height * 0.01 * 3,
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Scaffold.of(context).closeDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context)
                      .closeButtonTooltip,
                );
              },
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _periods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.update,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    "${_periods[index]} ${_periods[index] > 1 ? "hours" : "hour"}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(context).size.height * 0.01 * 1.7),
                  ),
                  onTap: () async {
                    await _onPeriodSelected(_periods[index], context, ref);
                  },
                );
              },
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
          ListTile(
            leading: Icon(
              Icons.restart_alt_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              "Reset Init State",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      MediaQuery.of(context).size.height * 0.01 * 1.7),
            ),
            onTap: () {
              ref.read(apiConfigNotifierProvider.notifier).reset();
            },
          ),
        ],
      ),
    );
  }
}
