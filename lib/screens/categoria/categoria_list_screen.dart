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
      appBar: AppBar(
        title: Text('Categorías'),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow[800],
      ),
      body: ListView.builder(
        itemCount: _categorias.length,
        itemBuilder: (_, index) {
          final cat = _categorias[index];
          return ListTile(
            title: Text(cat.nombre),
            subtitle: Text(cat.descripcion ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToForm(categoria: cat),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('¿Eliminar categoría?'),
                        content: Text('Esta acción no se puede deshacer.'),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              Navigator.pop(context); // cerrar el diálogo
                              _deleteCategoria(cat.id!); // ejecutar eliminación
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
