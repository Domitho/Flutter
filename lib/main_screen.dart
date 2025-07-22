import 'package:flutter/material.dart';
import 'screens/settings/login_screen.dart';

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
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.yellow[600]),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // Cuerpo de la pantalla (cualquier contenido dinámico)
      body: body,
      // Footer (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed, // para que muestre más de 4 ítems
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Pedidos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Empleados'),
        ],
        selectedItemColor: Colors.yellow[600],
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
