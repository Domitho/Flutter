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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar un mensaje si no hay pedidos
            if (_pedidos.isEmpty)
              Expanded(
                child: Center(child: Text('No hay pedidos registrados')),
              ),
            // Si hay pedidos, los mostramos
            if (_pedidos.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
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
                          pedido.customerName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Desayuno: ${pedido.breakfast.name}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              'Cantidad: ${pedido.quantity}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              'Total: \$${pedido.totalPrice}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            Text(
                              'Estado: ${pedido.status}',
                              style: TextStyle(
                                color: pedido.status == 'Completado'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            Text(
                              'Fecha: ${pedido.orderDate.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.black),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _navigateToForm(pedido: pedido);
                            } else if (value == 'delete') {
                              _deletePedido(pedido);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Botón flotante al final
            Container(
              width: double.infinity, // Hace que el botón ocupe todo el ancho
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () => _navigateToForm(),
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
                  'Crear pedido',
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
