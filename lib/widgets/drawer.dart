import 'dart:convert';

import 'package:bodegonapp/db/db.dart';
import 'package:bodegonapp/models/moneda.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:bodegonapp/models/tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<List<String>> _obtenerMonedas() async {
  return await DB.getAllMonedas();
}

Future _scan() async {
  await Permission.camera.request();
  String? barcode = await scanner.scan();
  // String barcode = '''
  // [
  //     {
  //         "codigo": "ABC123",
  //         "idGrupo": 1,
  //         "um": "unidad",
  //         "precioIndividual": 10.5,
  //         "cantidad": 5,
  //         "nombre": "Producto A",
  //         "nombrePersona": "Juan Pérez",
  //         "fecha": "2024-05-09",
  //         "destino": "Ciudad X"
  //     },
  //     {
  //         "codigo": "XYZ789",
  //         "idGrupo": 2,
  //         "um": "caja",
  //         "precioIndividual": 25.0,
  //         "cantidad": 2,
  //         "nombre": "Producto B",
  //         "nombrePersona": "María Rodríguez",
  //         "fecha": "2024-05-09",
  //         "destino": "Ciudad Y"
  //     }
  // ]
  // ''';
  if (barcode != null) {
    List<Producto> pro=List.empty(growable: true);
    var jsonList = json.decode(barcode)??'';
    for (var element in jsonList) {
      String codigo=element['codigo'];
      int idGrupo=element['idGrupo'];
      String um=element['um'];
      double precioIndividual=element['precioIndividual'];
      int cantidad=element['cantidad'];
      String nombre=element['nombre'];
      String nombrePersona=element['nombrePersona'];
      String fecha=element['fecha'];
      String destino=element['destino'];
    pro.add(Producto(codigo: codigo, idGrupo: idGrupo, um: um, precioIndividual: precioIndividual, cantidad: cantidad, nombre: nombre, nombrePersona: nombrePersona, fecha: fecha, destino: destino));
    }
  if(pro.isNotEmpty){
    DB.insertarProducto(pro);
  }
  }
  
}

Future<void> _dialogInsertTarjetas(context) async {
  List monedas = await _obtenerMonedas();
  String selected = monedas[0];
  String? newUnit = await showDialog<String>(
    context: context,
    builder: (context) {
      String? unit;
      return AlertDialog(
        title: const Text('Agregar Tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                unit = value;
              },
              decoration: const InputDecoration(
                labelText: 'Numero de la tarjeta nueva',
              ),
            ),
            DropdownButtonFormField<String>(
              onChanged: (String? newValue) {
                selected = newValue!;
              },
              value: selected,
              hint: Text(
                "Seleccione una jornada",
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
    await DB.insertarTarjeta(Tarjeta(monedas.indexOf(selected), newUnit!));
  }
}

Drawer drawer(context) {
  return Drawer(
      child: Stack(
    children: [
      ListView(
        padding: const EdgeInsets.all(0),
        children: [
          // const DrawerHeader(
          //   child: Text("Test de Romberg",
          //       style: TextStyle(
          //           color: Color.fromARGB(255, 49, 48, 47), fontSize: 24),
          //       textAlign: TextAlign.center),
          // ),
          ListTile(
            leading: const Icon(Icons.qr_code_2_sharp),
            title: const Text("Cargar Productos desde QR"),
            onTap: () {
              _scan();
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text("Cargar Productos desde Fichero"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_2_sharp),
            title: const Text("Actualizar Tipo de cambio desde QR"),
            onTap: () async {
              await DB.insertMoneda(Moneda("USD", 290.0));
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card_sharp),
            title: const Text("Inerstar tarjeta"),
            onTap: () async => _dialogInsertTarjetas(context),
          ),
        ],
      ),
    ],
  ));
}
