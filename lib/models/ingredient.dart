class Ingredient {
  int id;
  String nome;
  String imageUrl;

  Ingredient({required this.id, required this.nome, required this.imageUrl});

  Map<String, Object?> toMap() {
    return {'id': id, 'nome': nome, 'url': imageUrl};
  }
}
