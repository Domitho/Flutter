import 'package:flutter/material.dart';
import '../../models/pedidos_model.dart';
import '../../repositories/pedidos_repository.dart';
import 'pedidos_form_screen.dart';

class PedidosListScreen extends StatefulWidget {
  const PedidosListScreen({super.key});

  @override
  State<PedidosListScreen> createState() => _PedidosListScreenState();
}

class _PedidosListScreenState extends State<PedidosListScreen> {
  List<BreakfastOrder> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    final data = await PedidosRepository.list();
    setState(() {
      _pedidos = data;
    });
  }

  void _navigateToForm({BreakfastOrder? pedido}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PedidosFormScreen(order: pedido)),
    );
    _loadPedidos();
  }

  void _deletePedido(BreakfastOrder pedido) async {
    await PedidosRepository.delete(pedido);
    _loadPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: _pedidos.isEmpty
          ? Center(child: Text('No hay pedidos registrados'))
          : ListView.builder(
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                final pedido = _pedidos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(pedido.customerName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Desayuno: ${pedido.breakfast.name}'),
                        Text('Cantidad: ${pedido.quantity}'),
                        Text('Total: \$${pedido.totalPrice}'),
                        Text('Estado: ${pedido.status}'),
                        Text(
                          'Fecha: ${pedido.orderDate.toLocal().toString().split(' ')[0]}',
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToForm(pedido: pedido);
                        } else if (value == 'delete') {
                          _deletePedido(pedido);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Editar')),
                        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
