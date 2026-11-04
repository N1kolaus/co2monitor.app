import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'api_config_provider.g.dart';

/// SharedPreferences keys (kept compatible with the previously stored values).
const _prefKeyInitialized = 'wasInit';
const _prefKeyApiUrl = 'apiUrl';
const _prefKeyApiKey = 'apiKey';

/// The API configuration persisted on the device.
class ApiConfig {
  const ApiConfig({
    this.initialized = false,
    this.apiUrl = '',
    this.apiKey = '',
  });

  /// Whether the user has completed the initial setup.
  final bool initialized;
  final String apiUrl;
  final String apiKey;

  bool get isConfigured =>
      initialized && apiUrl.isNotEmpty && apiKey.isNotEmpty;
}

/// Loads, saves and resets the [ApiConfig] in [SharedPreferences].
@riverpod
class ApiConfigNotifier extends _$ApiConfigNotifier {
  @override
  Future<ApiConfig> build() async {
    final prefs = await SharedPreferences.getInstance();
    return ApiConfig(
      initialized: prefs.getBool(_prefKeyInitialized) ?? false,
      apiUrl: prefs.getString(_prefKeyApiUrl) ?? '',
      apiKey: prefs.getString(_prefKeyApiKey) ?? '',
    );
  }

  /// Persists a new configuration and marks the setup as completed.
  Future<void> configure(String apiUrl, String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_prefKeyInitialized, true),
      prefs.setString(_prefKeyApiUrl, apiUrl),
      prefs.setString(_prefKeyApiKey, apiKey),
    ]);
    state = AsyncData(
      ApiConfig(initialized: true, apiUrl: apiUrl, apiKey: apiKey),
    );
  }

  /// Forgets the configuration so the setup screen is shown again.
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_prefKeyInitialized, false),
      prefs.remove(_prefKeyApiUrl),
      prefs.remove(_prefKeyApiKey),
    ]);
    state = const AsyncData(ApiConfig());
  }
}
