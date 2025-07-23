import 'package:flutter/material.dart';
import '../../models/empleado_model.dart';
import '../../repositories/empleado_repository.dart';
import 'empleado_form_screen.dart';

class EmpleadoListScreen extends StatefulWidget {
  const EmpleadoListScreen({super.key});

  @override
  State<EmpleadoListScreen> createState() => _EmpleadoListScreenState();
}

class _EmpleadoListScreenState extends State<EmpleadoListScreen> {
  List<Empleado> _empleados = [];

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  void _cargarEmpleados() async {
    final data = await EmpleadoRepository.list();
    setState(() {
      _empleados = data;
    });
  }

  void _eliminarEmpleado(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('¿Eliminar empleado?'),
        content: Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await EmpleadoRepository.delete(id);
      _cargarEmpleados();
    }
  }

  void _irAlFormulario({Empleado? empleado}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmpleadoFormScreen(empleado: empleado)),
    );
    _cargarEmpleados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar mensaje si no hay empleados
            if (_empleados.isEmpty)
              Expanded(
                child: Center(child: Text('No hay empleados registrados')),
              ),
            // Mostrar la lista de empleados si hay datos
            if (_empleados.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _empleados.length,
                  itemBuilder: (_, i) {
                    final emp = _empleados[i];
                    return Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Bordes redondeados
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          emp.nombre,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          emp.rol,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _irAlFormulario(empleado: emp),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarEmpleado(emp.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Botón flotante para crear un nuevo empleado
            Container(
              width: double.infinity, // Hace que el botón ocupe todo el ancho
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () => _irAlFormulario(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Fondo negro
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Bordes redondeados
                  ),
                ),
                child: Text(
                  'Crear empleado',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
