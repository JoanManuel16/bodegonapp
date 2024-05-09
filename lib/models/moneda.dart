class Moneda{
  String moneda;
  double tipoCambio;
  Moneda(this.moneda,this.tipoCambio);
    Map<String, dynamic> toMap() {
    return {'moneda': moneda, 'tipoCambio':tipoCambio,};
  }
}