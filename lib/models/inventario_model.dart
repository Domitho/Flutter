class Breakfast {
  int? id;
  String name;
  String description;
  String code;
  int price;
  int stock;
  String imageUrl;
  int categoriaId; // ✅ NUEVO CAMPO

  Breakfast({
    this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.categoriaId, // ✅ requerido
  });

  // Método copyWith
  Breakfast copyWith({
    int? id,
    String? name,
    String? description,
    String? code,
    int? price,
    int? stock,
    String? imageUrl,
    int? categoriaId,
  }) {
    return Breakfast(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      categoriaId: categoriaId ?? this.categoriaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "code": code,
      "price": price,
      "stock": stock,
      "imageUrl": imageUrl,
      "categoria_id":
          categoriaId, // ✅ importante que coincida con la columna real
    };
  }

  factory Breakfast.fromMap(Map<String, dynamic> data) {
    return Breakfast(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      code: data["code"],
      price: data["price"],
      stock: data["stock"],
      imageUrl: data["imageUrl"],
      categoriaId: data["categoria_id"], // ✅
    );
  }
}
