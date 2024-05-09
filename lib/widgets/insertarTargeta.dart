import 'package:bodegonapp/db/db.dart';
import 'package:flutter/material.dart';
class InsertarTarjeta extends StatefulWidget {
  InsertarTarjeta({Key? key}) : super(key: key);

  @override
  _InsertarTarjetaState createState() => _InsertarTarjetaState();
}

class _InsertarTarjetaState extends State<InsertarTarjeta> {
 String selected='';
 List <String> monedas=[];
 Future<void> obtenerMonedas()async{
  List <String> aux = await DB.getAllMonedas();
    setState(() {
      monedas=aux;
    });
}
  @override
  Widget build(BuildContext context) {
    return Dialog(child: FutureBuilder(
    future: obtenerMonedas(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      
      return AlertDialog(content:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           DropdownButtonFormField<String>(
            onChanged: (String? newValue) {
                  setState(() {
                    selected = newValue!;
                  });
                },
           value: monedas[0],
           hint: const Text("Seleccione una moneda",
          style: TextStyle(color: Colors.black),
           ),
         items: monedas.map((item) => DropdownMenuItem<String>(
                  onTap:(){
                    setState(() {
                     selected=item;
                    });
                  }, 
                  value: item,
                  child: Text(item)),).toList(),
                  ),
        ],
      ),);
    },
  ),);
  }
}



