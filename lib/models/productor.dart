class Producto {
  String codigo;
  int idGrupo;
  String um;
  double precioIndividual;
  int cantidad;
  String nombre;
  String nombrePersona;
  String fecha;
  String destino;

  Producto({
    required this.codigo,
    required this.idGrupo,
    required this.um,
    required this.precioIndividual,
    required this.cantidad,
    required this.nombre,
    required this.nombrePersona,
    required this.fecha,
    required this.destino,
  });

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'idGrupo': idGrupo,
      'um': um,
      'precioIndividual': precioIndividual,
      'cantidad': cantidad,
      'nombre': nombre,
      'nombrePersona': nombrePersona,
      'fecha': fecha,
      'destino': destino,
    };
  }
}
