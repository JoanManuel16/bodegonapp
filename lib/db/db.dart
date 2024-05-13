import 'package:bodegonapp/models/moneda.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:bodegonapp/models/tarjeta.dart';
import 'package:bodegonapp/models/venta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sculptures.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE producto (id INTEGER PRIMARY KEY, codigo TEXT, idGrupo INTEGER, um TEXT, precioIndividual DOUBLE,  cantidad INTEGER,  nombre TEXT,  tipoMovimiento TEXT,  destino TEXT,  nombrePersona TEXT,  fecha TEXT)",
        );
        await db.execute(
          "CREATE TABLE cart (id INTEGER PRIMARY KEY, codigo TEXT, idGrupo INTEGER, um TEXT, precioIndividual DOUBLE,  cantidad INTEGER,  nombre TEXT,  tipoMovimiento TEXT,  destino TEXT,  nombrePersona TEXT,  fecha TEXT)",
        );
        await db.execute(
          "CREATE TABLE cierre (id_inicio INTEGER PRIMARY KEY, cierre INTEGER , fecha TEXT)",
        );
        await db.execute(
          "CREATE TABLE monedas (id_moneda INTEGER PRIMARY KEY, moneda INTEGER , tipoCambio INTEGER)",
        );
        await db.execute(
          "CREATE TABLE tarjetas (id_tarjeta INTEGER PRIMARY KEY, id_moneda INTEGER , numTarjeta TEXT)",
        );
        await db.execute(
          "CREATE TABLE venta (id_venta INTEGER PRIMARY KEY, codigo TEXT , cantidad INTEGER,moneda TEXT)",
        );
         await db.execute(
          "CREATE TABLE ventaTarjeta (id_venta INTEGER PRIMARY KEY, codigo TEXT , cantidad INTEGER,moneda TEXT,id_tarjeta INTEGER)",
        );
      },
      version: 2,
    );
  }

  static Future<List<String>> getAllMonedas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> provedoresMap =
        await database.query("monedas");

    return List.generate(
        provedoresMap.length, (i) => provedoresMap[i]['moneda']);
  }

 static Future<void> updateCantidad(Producto p) async {
  Database database = await _openDB();
  await database.update("producto", p.toMap(), where: 'codigo = ?', whereArgs: [p.codigo]);
}


  static Future<List<Producto>> getAllProducto() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> provedoresMap =
        await database.query("producto");
    List<Producto> pro = List.empty(growable: true);
    for (var element in provedoresMap) {
      pro.add(Producto(
        codigo: element['codigo'],
        idGrupo: element['idGrupo'],
        um: element['um'],
        precioIndividual: element['precioIndividual'],
        cantidad: element['cantidad'],
        nombre: element['nombre'],
        nombrePersona: element['nombrePersona'],
        fecha: element['fecha'],
        destino: element['destino'],
      ));
    }
    return pro;
  }

  static Future<List<Producto>> getAllCart() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> provedoresMap =
        await database.query("cart");

    return List.generate(
        provedoresMap.length,
        (i) => Producto(
            codigo: provedoresMap[i]['codigo'],
            idGrupo: provedoresMap[i]['idGrupo'],
            um: provedoresMap[i]['um'],
            precioIndividual: provedoresMap[i]['precioIndividual'],
            cantidad: provedoresMap[i]['cantidad'],
            nombre: provedoresMap[i]['nombre'],
            nombrePersona: provedoresMap[i]['nombrePersona'],
            fecha: provedoresMap[i]['fecha'],
            destino: provedoresMap[i]['destino']));
  }

  static Future<void> insertMoneda(Moneda mon) async {
    Database database = await _openDB();

    await database.insert("monedas", mon.toMap());
  }

  static Future<void> insertCart(Producto pro) async {
    Database database = await _openDB();

    await database.insert("cart", pro.toMap());
  }

  static Future<void> insertarTarjeta(Tarjeta tar) async {
    Database database = await _openDB();
    await database.insert("tarjetas", tar.toMap());
  }

  static Future<void> insertarProducto(List<Producto> pro) async {
    Database database = await _openDB();
    for (var producto in pro) {
      await database.insert("producto", producto.toMap());
    }
  }
  static Future<void> insertarVenta(List<Venta> pro) async {
    Database database = await _openDB();
    for (var producto in pro) {
      await database.insert("venta", producto.toJson());
    }
  }
   static Future<void> insertarVentaT(List<Venta> pro) async {
    Database database = await _openDB();
    for (var producto in pro) {
      await database.insert("ventaTarjeta", producto.toJsonT());
    }
  }
  static Future<void> eliminarCart() async {
  Database database = await _openDB();
  await database.delete("cart");
}

}
