import 'package:flutter/material.dart';
import 'main_screen.dart'; // Importa el widget MainScreen
import 'screens/inventario/inventario_screen.dart';

class DetallesScreen extends StatefulWidget {
  const DetallesScreen({super.key});

  @override
  _DetallesScreenState createState() => _DetallesScreenState();
}

class _DetallesScreenState extends State<DetallesScreen> {
  int _selectedIndex = 0;

  // Cambia la pantalla según el índice seleccionado en el footer
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Si se selecciona la opción "Inventario", navegamos a la pantalla de Inventario
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InventarioScreen(),
        ), // Navegar a Inventario
      );
    }
  }

  // Cuerpo de la pantalla
  @override
  Widget build(BuildContext context) {
    return MainScreen(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      body: Column(
        children: [
          // Accesos rápidos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Accesos rápidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildAccessButton('Registrar Desayuno', Icons.food_bank),
              _buildAccessButton('Ver Inventario', Icons.inventory),
            ],
          ),
        ],
      ),
    );
  }

  // Widget para crear los botones de acceso rápido
  Widget _buildAccessButton(String text, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        // Aquí puedes agregar la funcionalidad que necesitas cuando el usuario presiona un botón
        print('$text presionado');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.yellow[600]),
          Text(text, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
