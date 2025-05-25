class Ingredient {
  final int id;
  final String nome;
  final String imageUrl;

  Ingredient({required this.id, required this.nome, required this.imageUrl});

  Map<String, Object?> toMap() {
    return {'id': id, 'nome': nome, 'url': imageUrl};
  }
}
