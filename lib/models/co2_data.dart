import 'dart:convert';

/// A single CO2/temperature sensor reading returned by the CO2 API.
class Co2Reading {
  const Co2Reading({
    required this.date,
    required this.temp,
    required this.co2,
    required this.location,
  });

  final DateTime date;
  final double temp;
  final int co2;

  /// The `location_id` of the sensor that produced this reading.
  final int location;

  factory Co2Reading.fromJson(Map<String, dynamic> json) => Co2Reading(
        date: DateTime.parse(json['created_at'] as String).toLocal(),
        temp: (json['temp'] as num).toDouble(),
        co2: (json['co2'] as num).toInt(),
        location: (json['location_id'] as num).toInt(),
      );

  /// Placeholder shown before the API has been configured.
  factory Co2Reading.placeholder() => Co2Reading(
        date: DateTime.now(),
        temp: 0,
        co2: 0,
        location: 0,
      );

  @override
  String toString() =>
      'Co2Reading(date: $date, temp: $temp, co2: $co2, location: $location)';
}

/// The dashboard payload: the readings for the selected period plus the
/// most recent reading.
class Co2Dashboard {
  const Co2Dashboard({required this.series, required this.latest});

  /// Shown while the API is not configured or no data has been fetched.
  factory Co2Dashboard.empty() =>
      Co2Dashboard(series: const [], latest: Co2Reading.placeholder());

  final List<Co2Reading> series;
  final Co2Reading latest;
}

/// Decodes a JSON array of [Co2Reading] items.
List<Co2Reading> co2ReadingsFromJson(String str) {
  final decoded = jsonDecode(str) as List<dynamic>;
  return [
    for (final item in decoded)
      Co2Reading.fromJson(item as Map<String, dynamic>),
  ];
}
