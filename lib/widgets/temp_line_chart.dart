
import 'package:co2app/helpers/interval_helper.dart';
import 'package:co2app/models/co2_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A line chart of the temperature over the last [period] hours.
class TempLineChartWidget extends StatelessWidget {
  const TempLineChartWidget(this.points, {super.key, required this.period});

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
      case 5:
        text = "5";
        break;
      case 10:
        text = '10';
        break;
      case 15:
        text = '15';
        break;
      case 20:
        text = '20';
        break;
      case 25:
        text = '25';
        break;
      case 30:
        text = '30';
        break;
      case 35:
        text = '35';
        break;
      case 40:
        text = '40';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  double _getMaxTempValue() {
    return points.fold<double>(0, (m, p) => p.temp > m ? p.temp : m);
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
                    spots: _spots((p) => p.temp),
                    barWidth: 4,
                    isCurved: false,
                    dotData: const FlDotData(show: false),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
                minY: 0,
                maxY: _getMaxTempValue() + 10,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 50,
                      getTitlesWidget: _bottomTitleWidget,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
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
                      interval: 5,
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
                    return value == 5 ||
                        value == 10 ||
                        value == 15 ||
                        value == 20 ||
                        value == 25 ||
                        value == 30 ||
                        value == 35 ||
                        value == 40;
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
