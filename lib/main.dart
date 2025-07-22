import 'package:flutter/material.dart';
import 'screens/inventario/inventario_screen.dart';
import 'screens/pedidos/pedidos_list_screen.dart';
import 'main_screen.dart';
import 'screens/settings/login_screen.dart'; // ✅ NUEVO IMPORT

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paloma´s Restaurants',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: LoginScreen(), // ✅ MOSTRAR LOGIN INICIALMENTE
    );
  }
}

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    Center(child: Text('Bienvenido a Paloma´s Restaurants')),
    Center(child: Text('Balance (en construcción)')),
    PedidosListScreen(),
    InventarioScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      body: _screens[_selectedIndex],
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    );
  }
}
