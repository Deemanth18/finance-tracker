import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_3/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app shows login flow after splash', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SmartFinanceTrackerApp());
    expect(find.text('Student Finance Tracker'), findsOneWidget);

    // Advance past the bootstrap delay without waiting for all animations to settle.
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
