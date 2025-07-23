import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/settings/login_screen.dart';

class MainScreen extends StatefulWidget {
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
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
  }

  Future<void> _cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre_usuario') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paloma´s Restaurants'),
            if (_nombreUsuario.isNotEmpty)
              Text(
                'Hola, $_nombreUsuario',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
          ],
        ),
        backgroundColor: Colors.yellow[600],
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.yellow[600]),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Limpia la sesión
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

      // Cuerpo de la pantalla
      body: widget.body,

      // Footer (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
        type: BottomNavigationBarType.fixed,
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
