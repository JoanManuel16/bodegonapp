import 'package:bodegonapp/models/moneda.dart';
import 'package:bodegonapp/models/productor.dart';
import 'package:bodegonapp/models/tarjeta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sculptures.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE producto (id INTEGER PRIMARY KEY, codigo TEXT, idGrupo INTEGER, um TEXT, precioIndividual DOUBLE,  cantidad INTEGER,  nombre TEXT,  tipoMovimiento TEXT,  Destino TEXT,  nombrePersona TEXT,  fecha TEXT)",
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
          "CREATE TABLE venta (id_venta INTEGER PRIMARY KEY, id_producto INTEGER , cantidad INTEGER)",
        );
      },
      version: 1,
    );
  }

  static Future<List<String>> getAllMonedas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> provedoresMap =
        await database.query("monedas");

    return List.generate(
        provedoresMap.length, (i) => provedoresMap[i]['moneda']);
  }

  static Future<List<Producto>> getAllProducto() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> provedoresMap =
        await database.query("producto");

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
}
