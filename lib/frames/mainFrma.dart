import 'package:bodegonapp/db/db.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:bodegonapp/models/tarjeta.dart';
import 'package:bodegonapp/models/venta.dart';
import 'package:bodegonapp/widgets/cart.dart';
import 'package:bodegonapp/widgets/drawer.dart';
import 'package:bodegonapp/widgets/productosW.dart';
import 'package:flutter/material.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}
Future<List<String>> _obtenerMonedas() async {
  return await DB.getAllMonedas();
}

 



class _MainFrameState extends State<MainFrame> {
   int _currentIndex = 0;

  final List<Widget> _pages = [
     ProductosWidget(), // Página 1
     Cart()
  ];
  
  @override
  Widget build(BuildContext context) {
    
   Future<void> _dialogPagotarjeta(context) async {
  List monedas = await _obtenerMonedas();
  String selected = monedas[0];
  String? newUnit = await showDialog<String>(
    context: context,
    builder: (context) {
      String? unit;
      return AlertDialog(
        title: const Text('Pago en Tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              onChanged: (String? newValue) {
                selected = newValue!;
                unit=selected;
              },
              value: selected,
              hint: const Text(
                "Seleccione una moneda",
                style: TextStyle(color: Colors.black),
              ),
              items: monedas
                  .map(
                    (item) => DropdownMenuItem<String>(
                      onTap: () {
                        selected = item;
                      },
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo sin agregar la unidad
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context,
                  unit); // Cerrar el diálogo y pasar la unidad ingresada
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
  if (newUnit != '') {
    //utilizar la tarjeta del dia de la moneda especifica
    List <Producto> pro = await DB.getAllCart();
    List<Venta> venta= List.empty(growable: true);
    for (var producto in pro) {
      venta.add(Venta(codigo: producto.codigo, cantidad: producto.cantidad, moneda: newUnit!,id_tarjeta: 1));
    }
    await DB.insertarVentaT(venta);
    await DB.eliminarCart();
  }
}
   
   
   _mostrarDialogoMetodoPago(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccionar Método de Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                

                // Lógica para el pago en efectivo
                // Puedes agregar aquí la lógica correspondiente
              },
              child: const Text('Pago en Efectivo'),
            ),
            ElevatedButton(
              onPressed: () {
                 
                Navigator.of(context).pop(); // Cerrar el diálogo
               _dialogPagotarjeta(context);
                // Lógica para el pago con tarjeta
                // Puedes agregar aquí la lógica correspondiente
              },
              child: const Text('Pago con Tarjeta'),
            ),
          ],
        ),
      );
    },
  );
}
    
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.check_circle_sharp),
        onPressed: (){
          _mostrarDialogoMetodoPago(context);
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
