import '../models/usuario_model.dart';
import '../settings/db_connection.dart';

class UsuarioRepository {
  Future<UsuarioModel?> login(String email, String password) async {
    final data = await DbConnection.filter(
      'usuarios',
      'email = ? AND password = ?',
      [email, password],
    );

    if (data.isNotEmpty) {
      return UsuarioModel.fromMap(data.first);
    }
    return null;
  }

  Future<void> registrarUsuario(UsuarioModel usuario) async {
    await DbConnection.insert('usuarios', usuario.toMap());
  }
}
