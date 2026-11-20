import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sokna/core/di/service_locator.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/main.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initServiceLocator();
  });

  testWidgets('SoknaApp initializes and displays home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SoknaApp());
    await tester.pumpAndSettle();

    expect(find.text(APP_TITLE), findsOneWidget);
    expect(find.text(HOME_GREETING_TITLE), findsOneWidget);
  });
}
