import 'package:flutter/material.dart';
import '../../models/inventario_model.dart';
import '../../repositories/inventario_repository.dart';

class InventarioFormScreen extends StatefulWidget {
  final Breakfast? breakfast;

  const InventarioFormScreen({super.key, this.breakfast});

  @override
  State<InventarioFormScreen> createState() => _InventarioFormScreenState();
}

class _InventarioFormScreenState extends State<InventarioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

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
    }
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
              // Nombre del producto
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del producto *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Código
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Precio
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
              // Stock
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad disponible',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // URL Imagen
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL de la Imagen',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Botón Guardar
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
