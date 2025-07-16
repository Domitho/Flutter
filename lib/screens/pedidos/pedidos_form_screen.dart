import 'package:flutter/material.dart';
import '../../models/pedidos_model.dart';
import '../../models/inventario_model.dart';
import '../../repositories/pedidos_repository.dart';
import '../../repositories/inventario_repository.dart';

class PedidosFormScreen extends StatefulWidget {
  final BreakfastOrder? order;

  const PedidosFormScreen({super.key, this.order});

  @override
  State<PedidosFormScreen> createState() => _PedidosFormScreenState();
}

class _PedidosFormScreenState extends State<PedidosFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  List<Breakfast> _breakfastOptions = [];
  Breakfast? _selectedBreakfast;

  @override
  void initState() {
    super.initState();
    _loadBreakfasts();

    if (widget.order != null) {
      _customerNameController.text = widget.order!.customerName;
      _quantityController.text = widget.order!.quantity.toString();
      _statusController.text = widget.order!.status;
      _selectedBreakfast = widget.order!.breakfast;
    }
  }

  Future<void> _loadBreakfasts() async {
    final list = await BreakfastRepository.list();

    if (widget.order != null) {
      final matched = list.firstWhere(
        (item) => item.id == widget.order!.breakfast.id,
        orElse: () => list.first,
      );
      setState(() {
        _breakfastOptions = list;
        _selectedBreakfast = matched;
      });
    } else {
      setState(() {
        _breakfastOptions = list;
      });
    }
  }

  void saveOrder() async {
    if (_formKey.currentState!.validate() && _selectedBreakfast != null) {
      final int quantity = int.tryParse(_quantityController.text) ?? 0;
      final int total = _selectedBreakfast!.price * quantity;

      final newOrder = BreakfastOrder(
        id: widget.order?.id,
        customerName: _customerNameController.text,
        breakfast: _selectedBreakfast!,
        quantity: quantity,
        totalPrice: total,
        orderDate: DateTime.now(),
        status: _statusController.text,
      );

      if (widget.order == null) {
        await PedidosRepository.insert(newOrder);
      } else {
        await PedidosRepository.update(newOrder);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'Nuevo Pedido' : 'Editar Pedido'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nombre del cliente
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Cliente *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 16),

              // Selección de desayuno
              DropdownButtonFormField<Breakfast>(
                value: _selectedBreakfast,
                decoration: InputDecoration(
                  labelText: 'Desayuno *',
                  border: OutlineInputBorder(),
                ),
                items: _breakfastOptions.map((b) {
                  return DropdownMenuItem(value: b, child: Text(b.name));
                }).toList(),
                onChanged: (b) => setState(() => _selectedBreakfast = b),
                validator: (value) =>
                    value == null ? 'Seleccione un desayuno' : null,
              ),
              SizedBox(height: 16),

              // Cantidad
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cantidad *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Estado
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Estado del Pedido * (Pendiente, Entregado, etc)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 24),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.order == null
                        ? 'Registrar Pedido'
                        : 'Actualizar Pedido',
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
