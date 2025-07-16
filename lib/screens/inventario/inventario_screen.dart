import 'package:flutter/material.dart';
import '../../repositories/inventario_repository.dart';
import 'inventario_form_screen.dart';
import '../../models/inventario_model.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  late Future<List<Breakfast>> _inventarios;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _inventarios = BreakfastRepository.list();
    });
  }

  void _showOptionsDialog(BuildContext context, Breakfast inventario) {
    TextEditingController stockController = TextEditingController(
      text: inventario.stock.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Text(
                inventario.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$${inventario.price}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              // Mostrar la cantidad disponible
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cantidad disponible',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          int currentStock =
                              int.tryParse(stockController.text) ?? 0;
                          if (currentStock > 0) {
                            stockController.text = (currentStock - 1)
                                .toString();
                          }
                        },
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          int currentStock =
                              int.tryParse(stockController.text) ?? 0;
                          stockController.text = (currentStock + 1).toString();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botón de Actualizar cantidad
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int updatedStock = int.tryParse(stockController.text) ?? 0;
                    BreakfastRepository.update(
                      inventario.copyWith(stock: updatedStock),
                    ).then((_) {
                      Navigator.pop(context);
                      _loadData(); // Recargar datos después de actualizar
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Actualizar unidades',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Botón de Eliminar Producto con confirmación
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Mostrar el diálogo de confirmación de eliminación
                    _showDeleteConfirmationDialog(context, inventario);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Rojo para eliminar
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Eliminar Producto',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Botón de Editar Producto
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InventarioFormScreen(breakfast: inventario),
                      ),
                    ).then((_) {
                      _loadData(); // Recargar la lista después de editar
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Azul para editar
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Editar Producto',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // Cerrar el modal con el botón de cancelar
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el modal sin hacer nada
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Breakfast inventario,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Estás seguro de que deseas eliminar este producto?'),
          content: Text('Esta acción no se puede deshacer.'),
          actions: <Widget>[
            // Botón Cancelar
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Cerrar el cuadro de diálogo de confirmación
              },
              child: Text('Cancelar'),
            ),
            // Botón Confirmar
            TextButton(
              onPressed: () {
                // Eliminar el producto de la base de datos
                BreakfastRepository.delete(inventario).then((_) {
                  Navigator.pop(context); // Cerrar el cuadro de confirmación
                  Navigator.pop(context); // Cerrar el modal de opciones
                  _loadData(); // Recargar la lista después de eliminar
                });
              },
              child: Text('Confirmar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Breakfast>>(
        future: _inventarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/lista.png', width: 150, height: 150),
                  SizedBox(height: 20),
                  Text(
                    'Aún no tienes registros creados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Empieza agregando uno en el botón "Crear producto"',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            List<Breakfast> inventarios = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: inventarios.length,
                    itemBuilder: (context, index) {
                      var inventario = inventarios[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inventario.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${inventario.stock} disponibles',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$${inventario.price}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {
                                  _showOptionsDialog(context, inventario);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventarioFormScreen(),
                        ),
                      ).then((_) {
                        _loadData();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Crear producto',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
