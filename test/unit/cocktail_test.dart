import 'package:flutter_test/flutter_test.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/models/cocktail.dart';

void main() {
  group('Cocktail', () {
    test('toMapSmall() restituisce mappa con solo titolo e descrizione', () {
      final ingredient1 = Ingredient(id: 1, nome: 'gin', imageUrl: 'gin.png');
      final ingredient2 = Ingredient(id: 2, nome: 'tonica', imageUrl: 'tonica.png');
      final cocktail1 = Cocktail(
        id: 10,
        title: 'Mojito',
        description: 'mescolare gin e tonica con ghiaccio',
        ingredients: [ingredient1, ingredient2],
      );

      final map = cocktail1.toMapSmall();

      expect(map, {
        'title': 'Mojito',
        'description': 'mescolare gin e tonica con ghiaccio',
      });
    });

    test('toMap() restituisce mappa completa', () {
      final ingredient3 = Ingredient(id: 3, nome: 'cola', imageUrl: 'cola.png');
      final ingredient4 = Ingredient(id: 4, nome: 'rum', imageUrl: 'rum.png');
      final cocktail2 = Cocktail(
        id: null,
        title: 'Cuba Libre',
        description: 'mescolare rum e cola con ghiaccio',
        ingredients: [ingredient3, ingredient4],
      );
      final map = cocktail2.toMap();

      expect(map['id'], null);
      expect(map['title'], 'Cuba Libre');
      expect(map['recipe'], 'mescolare rum e cola con ghiaccio');
      expect(map['ingredients'], [
        {'id': 3, 'nome': 'cola', 'url': 'cola.png'},
        {'id': 4, 'nome': 'rum', 'url': 'rum.png'},
      ]);
    });

    test('copyWith() sovrascrive solo i valori specificati', () {
      final ingredient5 = Ingredient(id: 1, nome: 'gin', imageUrl: 'gin.png');
      final ingredient6 = Ingredient(
        id: 2,
        nome: 'tonica',
        imageUrl: 'tonica.png',
      );
      final cocktail3 = Cocktail(
        id: null,
        title: 'Mojito',
        description: 'mescolare gin e tonica con ghiaccio',
        ingredients: [ingredient5, ingredient6],
      );
      final modified = cocktail3.copyWith(id: 10);

      expect(modified.id, 10);
      expect(modified.title, 'Mojito');
      expect(modified.description, 'mescolare gin e tonica con ghiaccio');
      expect(modified.ingredients.length, 2);
      expect(modified.ingredients[0], ingredient5);
      expect(modified.ingredients[1], ingredient6);
    });

    test('costruisce un oggetto Cocktail corretto dalla mappa', () {
      final map = {
        'id': 42,
        'title': 'Negroni',
        'recipe': 'Mescola gin, vermouth rosso e Campari.',
        'ingredients': [
          {'id': 1, 'nome': 'Gin', 'url': 'gin.png'},
          {'id': 2, 'nome': 'Campari', 'url': 'campari.png'},
        ],
      };

      final cocktail = Cocktail.fromMap(map);

      expect(cocktail.id, 42);
      expect(cocktail.title, 'Negroni');
      expect(cocktail.description, 'Mescola gin, vermouth rosso e Campari.');
      expect(cocktail.ingredients.length, 2);

      expect(cocktail.ingredients[0].id, 1);
      expect(cocktail.ingredients[0].nome, 'Gin');
      expect(cocktail.ingredients[0].imageUrl, 'gin.png');

      expect(cocktail.ingredients[1].id, 2);
      expect(cocktail.ingredients[1].nome, 'Campari');
      expect(cocktail.ingredients[1].imageUrl, 'campari.png');
    });
  });
}
