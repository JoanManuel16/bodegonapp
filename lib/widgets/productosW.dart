import 'package:bodegonapp/db/db.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:flutter/material.dart';

class ProductosWidget extends StatelessWidget {
  const ProductosWidget({super.key});

  // Método para obtener los productos (simulado aquí)
  Future<List<Producto>> obtenerProductos() async {
    return await DB.getAllProducto();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: obtenerProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra el círculo de progreso mientras carga
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Manejo de errores si ocurren
          return const Center(
            child: Icon(Icons.error_sharp),
          );
        } else if (!snapshot.hasData) {
          // No hay datos disponibles
          return const Center(
            child: Icon(Icons.content_paste_off)
          );
        } else {
          // Datos cargados, muestra los productos en tarjetas
          final List<Producto> productos = snapshot.data!;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) {
              final producto = productos[index];
              return Card(
                child: ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Precio: \$${producto.precioIndividual}'),
                  onTap: () {
                    _showAddToCartDialog(context, producto);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  // Función para mostrar el diálogo de agregar al carrito
  void _showAddToCartDialog(BuildContext context, Producto producto) {
    int cantidad = 0; // Inicializar con 1 o la cantidad deseada
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar al carrito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  cantidad = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if(cantidad!=0 && cantidad>0){
                  //logica aqui
                }
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
