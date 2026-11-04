import 'dart:convert';

import 'package:co2app/models/co2_data.dart';
import 'package:http/http.dart' as http;

/// Thrown when the CO2 API returns a non-2xx response.
class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => 'ApiException: $message';
}

/// Thin, testable client for the CO2 monitor API.
class Co2ApiClient {
  Co2ApiClient({
    required http.Client client,
    required String baseUrl,
    required String apiKey,
  })  : _client = client,
        _baseUrl = baseUrl,
        _apiKey = apiKey;

  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  static const _searchPath = '/api/co2data/1/search';
  static const _latestPath = '/api/co2data/1/latest';
  static const _apiKeyHeader = 'X-API-KEY';

  /// Fetches the readings for the last [periodHours] hours.
  Future<List<Co2Reading>> fetchRange(int periodHours) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl$_searchPath?period=${periodHours}h'),
      headers: _headers,
    );
    _throwIfError(response);
    return co2ReadingsFromJson(response.body);
  }

  /// Fetches the most recent reading.
  Future<Co2Reading> fetchLatest() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl$_latestPath'),
      headers: _headers,
    );
    _throwIfError(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Co2Reading.fromJson(decoded);
  }

  Map<String, String> get _headers => {_apiKeyHeader: _apiKey};

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException('HTTP ${response.statusCode}');
    }
  }
}
