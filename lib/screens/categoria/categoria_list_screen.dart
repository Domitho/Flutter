import 'package:flutter/material.dart';
import '../../models/categoria_model.dart';
import '../../repositories/categoria_repository.dart';
import 'categoria_form_screen.dart';

class CategoriaListScreen extends StatefulWidget {
  const CategoriaListScreen({super.key});

  @override
  State<CategoriaListScreen> createState() => _CategoriaListScreenState();
}

class _CategoriaListScreenState extends State<CategoriaListScreen> {
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  void _loadCategorias() async {
    final data = await CategoriaRepository.list();
    setState(() {
      _categorias = data;
    });
  }

  void _deleteCategoria(int id) async {
    await CategoriaRepository.delete(id);
    _loadCategorias();
  }

  void _navigateToForm({Categoria? categoria}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoriaFormScreen(categoria: categoria),
      ),
    );
    _loadCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _categorias.length,
                itemBuilder: (_, index) {
                  final cat = _categorias[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.nombre,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  cat.descripcion ?? '',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _navigateToForm(categoria: cat),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('¿Eliminar categoría?'),
                                      content: Text(
                                        'Esta acción no se puede deshacer.',
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Eliminar',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(
                                              context,
                                            ); // cerrar el diálogo
                                            _deleteCategoria(
                                              cat.id!,
                                            ); // ejecutar eliminación
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Botón en la parte inferior
            Container(
              width: double.infinity, // Esto hace que ocupe todo el ancho
              margin: EdgeInsets.only(bottom: 5), // Márgenes para espacio
              child: ElevatedButton(
                onPressed: () => _navigateToForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Fondo negro
                  padding: EdgeInsets.symmetric(vertical: 12), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Borde redondeado
                  ),
                ),
                child: Text(
                  'Crear categoría', // Texto del botón
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ), // Texto blanco
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
