import 'package:flutter/material.dart';
import '../../models/categoria_model.dart';
import '../../repositories/categoria_repository.dart';

class CategoriaFormScreen extends StatefulWidget {
  final Categoria? categoria;

  const CategoriaFormScreen({super.key, this.categoria});

  @override
  State<CategoriaFormScreen> createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _nombreController.text = widget.categoria!.nombre;
      _descripcionController.text = widget.categoria!.descripcion ?? '';
    }
  }

  void _saveCategoria() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now().toIso8601String();

      final nuevaCategoria = Categoria(
        id: widget.categoria?.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        createdAt: widget.categoria?.createdAt ?? now,
      );

      if (widget.categoria == null) {
        await CategoriaRepository.insert(nuevaCategoria);
      } else {
        await CategoriaRepository.update(nuevaCategoria);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria == null ? 'Nueva Categoría' : 'Editar Categoría',
        ),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Categoría *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCategoria,
                child: Text(
                  widget.categoria == null ? 'Guardar' : 'Actualizar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
