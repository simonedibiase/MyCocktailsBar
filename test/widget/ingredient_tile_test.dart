import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/widget/ingredient_tile.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('IngredientTile displays ingredient data', (
    WidgetTester tester,
  ) async {
    final ingredient = Ingredient(
      id: 1,
      nome: 'Limone',
      imageUrl: 'https://example.com/limone.png',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: IngredientTile(ingredient))),
      );

      expect(find.text('Limone'), findsOneWidget);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget(imageFinder);
      expect(imageWidget.image, isA<NetworkImage>());
      
      final networkImage = imageWidget.image as NetworkImage;
      expect(networkImage.url, equals('https://example.com/limone.png'));
    });
  });
}
