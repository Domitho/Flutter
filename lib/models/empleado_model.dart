class Empleado {
  final int? id;
  final String nombre;
  final String rol;
  final String? telefono;
  final String? email;

  Empleado({
    this.id,
    required this.nombre,
    required this.rol,
    this.telefono,
    this.email,
  });

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      id: map['id'],
      nombre: map['nombre'],
      rol: map['rol'],
      telefono: map['telefono'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'rol': rol,
      'telefono': telefono,
      'email': email,
    };
  }
}
