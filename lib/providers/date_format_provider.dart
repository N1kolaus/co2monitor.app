import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// The date format used for reading timestamps in the UI.
final dateFormatterProvider = Provider<DateFormat>((ref) {
  return DateFormat("yyyy.MM.dd - HH:mm");
});
