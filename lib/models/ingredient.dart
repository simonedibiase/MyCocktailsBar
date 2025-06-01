class Ingredient {
  int id;
  String nome;
  String imageUrl;

  Ingredient({required this.id, required this.nome, required this.imageUrl});

  Map<String, Object?> toMap() {
    return {'id': id, 'nome': nome.toLowerCase().trim(), 'url': imageUrl};
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as int,
      nome: map['nome'] as String,
      imageUrl: map['url'] as String,
    );
  }
}
