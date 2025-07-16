class Breakfast {
  int? id;
  String name;
  String description;
  String code;
  int price;
  int stock;
  String imageUrl;

  Breakfast({
    this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // Método copyWith para actualizar los campos que deseas
  Breakfast copyWith({
    int? id,
    String? name,
    String? description,
    String? code,
    int? price,
    int? stock,
    String? imageUrl,
  }) {
    return Breakfast(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      code: code ?? this.code,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Métodos de transformación de clase a mapa
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "code": code,
      "price": price,
      "stock": stock,
      "imageUrl": imageUrl,
    };
  }

  // Factory method to create an instance of Breakfast from a map
  factory Breakfast.fromMap(Map<String, dynamic> data) {
    return Breakfast(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      code: data["code"],
      price: data["price"],
      stock: data["stock"],
      imageUrl: data["imageUrl"],
    );
  }
}
