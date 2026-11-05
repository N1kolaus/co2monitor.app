import 'package:co2app/providers/data_provider.dart';
import 'package:co2app/providers/date_format_provider.dart';
import 'package:co2app/providers/period_provider.dart';
import 'package:co2app/widgets/temp_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/co2_line_chart.dart';

/// The dashboard body: the latest reading plus the CO2 and temperature
/// charts for the selected period.
class LineChartScreen extends ConsumerWidget {
  const LineChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataProv = ref.watch(co2DataProvider);
    final dateFormatter = ref.watch(dateFormatterProvider);
    final period =
        ref.watch(periodNotifierProvider.select((s) => s.value?.period ?? 1));

    return dataProv.when(
      data: (dashboard) => ListView(
        children: <Widget>[
          Center(
            child: Text(
              "${dateFormatter.format(dashboard.latest.date)}, CO2: ${dashboard.latest.co2}, Temp: ${dashboard.latest.temp}, Period: ${period}h",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.01 * 1.7,
              ),
            ),
          ),
          Co2LineChartWidget(dashboard.series, period: period),
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
          TempLineChartWidget(dashboard.series, period: period),
        ],
      ),
      error: (err, _) => Center(
        child: Text("Data could not be loaded: \n$err"),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
