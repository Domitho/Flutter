import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MainScreen({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text('Paloma´s Restaurants'),
        backgroundColor: Colors.yellow[600],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.yellow[600]),
            ),
          ),
        ],
      ),
      // Cuerpo de la pantalla (cualquier contenido dinámico)
      body: body,
      // Footer (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Balance',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Pedidos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
        ],
        selectedItemColor: Colors.yellow[600],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
