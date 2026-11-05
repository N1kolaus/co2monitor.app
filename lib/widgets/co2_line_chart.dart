import 'dart:math';

import 'package:co2app/helpers/interval_helper.dart';
import 'package:co2app/models/co2_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A line chart of CO2 values over the last [period] hours, with threshold
/// lines at 800, 1000 and 1200 ppm.
class Co2LineChartWidget extends StatelessWidget {
  const Co2LineChartWidget(this.points, {super.key, required this.period});

  final List<Co2Reading> points;
  final int period;

  /// X-axis positions: the index of every reading.
  List<FlSpot> _spots(double Function(Co2Reading) value) {
    return [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), value(points[i])),
    ];
  }

  Widget _bottomTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    final index = value.toInt();
    final String text;
    if (index < 0 || index > points.length - 3) {
      // Blank the last few labels so the chart is not cramped.
      text = "";
    } else {
      text = DateFormat("HH:mm").format(points[index].date);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget _leftTitleWidget(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    String text = '';
    switch (value.toInt()) {
      case 500:
        text = "500";
        break;
      case 1000:
        text = '1k';
        break;
      case 1500:
        text = '1.5k';
        break;
      case 2000:
        text = '2k';
        break;
      case 2500:
        text = '2.5k';
        break;
      case 3000:
        text = '3k';
        break;
      case 3500:
        text = '3.5k';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  double _getMaxCo2Value() {
    return points.fold<double>(0, (m, p) => p.co2.toDouble() > m ? p.co2.toDouble() : m);
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final interval = const IntervalHelper()
        .calculateInterval(context, period)
        .toDouble();

    return OrientationBuilder(
      builder: (context, orientation) {
        return AspectRatio(
          aspectRatio: orientation == Orientation.portrait ? 2 : 3,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
              bottom: 5,
            ),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots((p) => p.co2.toDouble()),
                    barWidth: 4,
                    isCurved: false,
                    dotData: const FlDotData(show: false),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  LineChartBarData(
                    spots: _spots((p) => 800),
                    barWidth: 4,
                    isCurved: false,
                    dotData: const FlDotData(show: false),
                    color: Colors.green.withValues(alpha: 0.5),
                  ),
                  LineChartBarData(
                    spots: _spots((p) => 1000),
                    barWidth: 4,
                    isCurved: false,
                    dotData: const FlDotData(show: false),
                    color: Colors.orange.withValues(alpha: 0.5),
                  ),
                  LineChartBarData(
                    spots: _spots((p) => 1200),
                    barWidth: 4,
                    isCurved: false,
                    dotData: const FlDotData(show: false),
                    color: Colors.red.withValues(alpha: 0.5),
                  ),
                ],
                minY: 0,
                maxY: max(_getMaxCo2Value() + 300, 1500),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 30,
                      getTitlesWidget: _bottomTitleWidget,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      reservedSize: 40,
                      getTitlesWidget: _leftTitleWidget,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      reservedSize: 40,
                      getTitlesWidget: _leftTitleWidget,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: interval,
                  checkToShowHorizontalLine: (double value) {
                    return value == 500 ||
                        value == 1000 ||
                        value == 1500 ||
                        value == 2000 ||
                        value == 2500 ||
                        value == 3000 ||
                        value == 3500;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
