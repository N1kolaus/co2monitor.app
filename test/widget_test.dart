import 'package:co2app/main.dart';
import 'package:co2app/providers/data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

http.Client _fakeApi() {
  return MockClient((request) async {
    if (request.url.path.contains('search')) {
      return http.Response('[]', 200);
    }
    return http.Response(
      '''{
        "created_at": "2024-01-01T12:00:00.000",
        "temp": 20,
        "co2": 600,
        "location_id": 1
      }''',
      200,
    );
  });
}

void main() {
  testWidgets('shows the setup screen when the API is not configured',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: Co2App()));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your API URL and key'), findsOneWidget);
    expect(find.text('API URL'), findsOneWidget);
    expect(find.text('API key'), findsOneWidget);
  });

  testWidgets('shows the dashboard when the API is configured',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'wasInit': true,
      'apiUrl': 'http://api.test',
      'apiKey': 'secret',
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [httpClientProvider.overrideWithValue(_fakeApi())],
        child: const Co2App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CO2Monitor'), findsOneWidget);
  });
}
