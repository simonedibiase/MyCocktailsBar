import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_coctails_bar/widget/header.dart';

void main() {
  Future<void> setupWidget(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Header())));
  }

  testWidgets('Header renders image, text, and layout correctly', (
    WidgetTester tester,
  ) async {
    await setupWidget(tester);

    final textFinder = find.text('What do you want\n to cook today?');
    expect(textFinder, findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/sfondo1.png');

    expect(find.byType(ClipRRect), findsOneWidget);

    //Verifica proporzione dell'altezza
    final screenHeight = tester.getSize(find.byType(MaterialApp)).height;
    final headerHeight = tester.getSize(find.byType(Header)).height;
    expect(headerHeight, closeTo(screenHeight * 0.32, 1.0));
  });
}
