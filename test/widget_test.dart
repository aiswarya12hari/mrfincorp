import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/CORE/Storage/shared_preference.dart';
import 'package:mr_fincorp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  testWidgets('FincorpApp smoke test boots properly', (WidgetTester tester) async {
    await tester.pumpWidget(const FincorpApp());
    await tester.pumpAndSettle();
    expect(find.byType(FincorpApp), findsOneWidget);
  });
}
