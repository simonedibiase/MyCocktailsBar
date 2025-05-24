class Ingredient {
  int? id;
  final String nome;
  final String imageUrl;

  Ingredient({this.id, required this.nome, required this.imageUrl});

  Ingredient.db({required this.id, required this.nome, required this.imageUrl});

  Map<String, Object?> toMap() {
    return {'nome': nome, 'url': imageUrl};
  }

  Ingredient copyWith({int? id, String? nome, String? imageUrl}) {
    return Ingredient(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
