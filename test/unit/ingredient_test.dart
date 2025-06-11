import 'package:flutter_test/flutter_test.dart';
import 'package:my_coctails_bar/models/ingredient.dart';

void main() {
  group('Ingredient', () {
    test('toMap() restituisce una mappa corretta', () {
      final ingredient = Ingredient(
        id: 1,
        nome: ' Pomodoro ',
        imageUrl: 'url_immagine',
      );

      final map = ingredient.toMap();

      expect(map, {'id': 1, 'nome': 'pomodoro', 'url': 'url_immagine'});
    });

    test('fromMap() costruisce correttamente l\'oggetto', () {
      final map = {'id': 2, 'nome': 'basilico', 'url': 'immagine_basilico'};

      final ingredient = Ingredient.fromMap(map);

      expect(ingredient.id, 2);
      expect(ingredient.nome, 'basilico');
      expect(ingredient.imageUrl, 'immagine_basilico');
    });

    test('fromMap(toMap()) ricostruisce lo stesso oggetto', () {
      final original = Ingredient(
        id: 3,
        nome: ' Cipolla ',
        imageUrl: 'url_cipolla',
      );
      final copy = Ingredient.fromMap(original.toMap());

      expect(copy.id, original.id);
      expect(copy.nome, original.nome.toLowerCase().trim());
      expect(copy.imageUrl, original.imageUrl);
    });
  });
}
