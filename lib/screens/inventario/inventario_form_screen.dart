import 'package:flutter/material.dart';
import '../../models/inventario_model.dart';
import '../../models/categoria_model.dart';
import '../../repositories/inventario_repository.dart';
import '../../repositories/categoria_repository.dart';

class InventarioFormScreen extends StatefulWidget {
  final Breakfast? breakfast;

  const InventarioFormScreen({super.key, this.breakfast});

  @override
  State<InventarioFormScreen> createState() => _InventarioFormScreenState();
}

class _InventarioFormScreenState extends State<InventarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  List<Categoria> _categorias = [];
  int? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.breakfast != null) {
      _nameController.text = widget.breakfast!.name;
      _descriptionController.text = widget.breakfast!.description;
      _codeController.text = widget.breakfast!.code;
      _priceController.text = widget.breakfast!.price.toString();
      _stockController.text = widget.breakfast!.stock.toString();
      _imageUrlController.text = widget.breakfast!.imageUrl;
      _categoriaSeleccionada = widget.breakfast!.categoriaId;
    }

    _cargarCategorias();
  }

  void _cargarCategorias() async {
    final categorias = await CategoriaRepository.list();
    setState(() {
      _categorias = categorias;
      _categoriaSeleccionada ??= categorias.isNotEmpty
          ? categorias.first.id
          : null;
    });
  }

  void saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final newBreakfast = Breakfast(
        id: widget.breakfast?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        code: _codeController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        imageUrl: _imageUrlController.text,
        categoriaId: _categoriaSeleccionada!,
      );

      if (widget.breakfast == null) {
        await BreakfastRepository.insert(newBreakfast);
      } else {
        await BreakfastRepository.update(newBreakfast);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.breakfast == null ? 'Crear producto' : 'Editar producto',
        ),
        backgroundColor: Colors.yellow[600],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del producto *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un valor numérico';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad disponible',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL de la Imagen',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _categoriaSeleccionada,
                decoration: InputDecoration(
                  labelText: 'Categoría *',
                  border: OutlineInputBorder(),
                ),
                items: _categorias.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleccione una categoría' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.breakfast == null ? 'Guardar' : 'Actualizar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
