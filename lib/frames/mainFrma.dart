import 'package:bodegonapp/widgets/cart.dart';
import 'package:bodegonapp/widgets/drawer.dart';
import 'package:bodegonapp/widgets/productosW.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
   int _currentIndex = 0;

  final List<Widget> _pages = [
     ProductosWidget(), // Página 1
  ];
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.check_circle_sharp),
        onPressed: (){

      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,color: Colors.green,),
            label: 'Carrito',
          ),
        ],
      ),
 
      appBar: AppBar(
        title: const Text('Tienda'),
      ),
      drawer: drawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
    );
  }
}
