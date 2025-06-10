import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_coctails_bar/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test: intro + navigation', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'isFirstTime': true});

    app.main();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('first_screen')), findsOneWidget);

    final introButton = find.byKey(const Key('intro_forward_button'));
    expect(introButton, findsOneWidget);
    await tester.tap(introButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ingredients_screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_category')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('category_screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_favorite')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('favorites_screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav_ingredients')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ingredients_screen')), findsOneWidget);
  });
}
