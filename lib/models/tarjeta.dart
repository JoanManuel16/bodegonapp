class Tarjeta{
  String numTarjeta;
  int id_moneda;
  Tarjeta(this.id_moneda,this.numTarjeta);
   Map<String, dynamic> toMap() {
    return {'numTarjeta': numTarjeta, 'id_moneda':id_moneda,};
  }
}