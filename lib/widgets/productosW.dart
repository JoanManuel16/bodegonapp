import 'package:bodegonapp/db/db.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:flutter/material.dart';

class ProductosWidget extends StatefulWidget {
  
  @override
  State<ProductosWidget> createState() => _ProductosWidgetState();
}

class _ProductosWidgetState extends State<ProductosWidget> {
  Future<List<Producto>>?_data;
    String searchString = ''; // Variable para almacenar la cadena de búsqueda
  // Método para obtener los productos (simulado aquí)
  Future<List<Producto>> obtenerProductos() async {
    return await DB.getAllProducto();
  }
@override
  void initState() {
    _data=obtenerProductos();
    super.initState();
  }
  @override
 Widget build(BuildContext context) {
  return RefreshIndicator(
    onRefresh: () async {
      // Aquí puedes realizar la lógica para actualizar la lista de productos
      setState(() {
        // Por ejemplo, puedes volver a cargar los datos desde la fuente de datos
        _data = obtenerProductos(); // Suponiendo que fetchData() es la función que obtiene los datos
      });
    },
    child: Column(
      children: [
        // Agrega un TextField para la búsqueda
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchString = value; // Actualiza la cadena de búsqueda
              });
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar productos',
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Producto>>(
            future: _data,
            builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Icon(Icons.error_sharp),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: Icon(Icons.content_paste_off));
              } else {
                List<Producto> productos = snapshot.data!;
                // Filtra la lista de productos según la cadena de búsqueda
                List<Producto> filteredProductos = productos.where((producto) =>
                  producto.nombre.toLowerCase().contains(searchString.toLowerCase())
                ).toList();

                return ListView.builder(
                  itemCount: filteredProductos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final producto = filteredProductos[index];
                    return Card(
                      child: ListTile(
                        title: Text(producto.nombre),
                        subtitle: Text('Precio: \$${producto.precioIndividual}\n Cantidad: ${producto.cantidad}'),
                        onTap: () {
                          _showAddToCartDialog(context, producto);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
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
              onPressed: () async {
                if (cantidad != 0 && cantidad > 0) {
                  int aux= producto.cantidad;
                  producto.cantidad=cantidad;
                 await DB.insertCart(producto);
                 producto.cantidad=aux-producto.cantidad;
                await DB.updateCantidad(producto);
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
