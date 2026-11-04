import 'package:flutter/material.dart';

/// Computes the x-axis title interval (in data points) for the line charts,
/// scaled to the selected period and the screen width.
class IntervalHelper {
  const IntervalHelper();

  int calculateInterval(BuildContext context, int period) {
    var interval = 10;
    switch (period) {
      case 1:
        interval = interval.round();
        break;
      case 3:
        interval = (interval * 3).round();
        break;
      case 6:
        interval = (interval * 6).round();
        break;
      case 12:
        interval = (interval * 12).round();
        break;
      case 24:
        interval = (interval * 24).round();
        break;
      case 48:
        interval = (interval * 48).round();
        break;
    }

    final width = MediaQuery.of(context).size.width;
    if (width > 800 && width < 1200) {
      interval = (interval / 2).round();
    }
    if (width >= 1200) {
      interval = (interval / 4).round();
    }

    return interval;
  }
}
