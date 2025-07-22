import 'package:flutter/material.dart';
import '../../models/empleado_model.dart';
import '../../repositories/empleado_repository.dart';

class EmpleadoFormScreen extends StatefulWidget {
  final Empleado? empleado;

  const EmpleadoFormScreen({super.key, this.empleado});

  @override
  State<EmpleadoFormScreen> createState() => _EmpleadoFormScreenState();
}

class _EmpleadoFormScreenState extends State<EmpleadoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _rolController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.empleado != null) {
      _nombreController.text = widget.empleado!.nombre;
      _rolController.text = widget.empleado!.rol;
      _telefonoController.text = widget.empleado!.telefono ?? '';
      _emailController.text = widget.empleado!.email ?? '';
    }
  }

  void _guardarEmpleado() async {
    if (_formKey.currentState!.validate()) {
      final nuevo = Empleado(
        id: widget.empleado?.id,
        nombre: _nombreController.text,
        rol: _rolController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
      );

      if (widget.empleado == null) {
        await EmpleadoRepository.insert(nuevo);
      } else {
        await EmpleadoRepository.update(nuevo);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.empleado == null ? 'Nuevo Empleado' : 'Editar Empleado',
        ),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _rolController,
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarEmpleado,
                child: Text(widget.empleado == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
