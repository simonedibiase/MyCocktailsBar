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
      imageUrl: '/mock/path/lemon.png',
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: IngredientTile(ingredient))),
    );

    // Verifica che il nome venga visualizzato
    expect(find.text('Limone'), findsOneWidget);

    // Verifica che venga mostrato un'immagine (Image widget)
    expect(
      tester.widget<Image>(find.byType(Image)).image,
      isA<FileImage>().having(
        (img) => img.file.path,
        'file path',
        '/mock/path/lemon.png',
      ),
    );
  });
}
