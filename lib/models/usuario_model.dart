class UsuarioModel {
  int? id;
  String nombre;
  String email;
  String password;

  UsuarioModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'email': email, 'password': password};
  }

  static UsuarioModel fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      nombre: map['nombre'],
      email: map['email'],
      password: map['password'],
    );
  }
}
