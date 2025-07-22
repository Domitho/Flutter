class Categoria {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String? createdAt;

  Categoria({this.id, required this.nombre, this.descripcion, this.createdAt});

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'created_at': createdAt,
    };
  }
}
