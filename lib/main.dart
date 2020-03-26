import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=2e8200c7";

main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),

  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController  = TextEditingController();
  final dolarController  = TextEditingController();
  final euroController  = TextEditingController();
  double dolar, euro;

  void _realChanged(String text){
    double real = double.parse(text);

    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);


  }
  void _dolarlChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de Moeda"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:

            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Oopps. tivemos um erro inesperado",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on, size: 150.00, color: Colors.amber
                      ),
                      buildTextFiel("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextFiel("Dólares", "US\$", dolarController, _dolarlChanged),
                      Divider(),
                      buildTextFiel("Euros", "€", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextFiel(String label, String prefix, TextEditingController tec, Function function){
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: TextStyle(
            color: Colors.amber
        )

    ),
    style: TextStyle(color: Colors.amber),
    onChanged: function,
    keyboardType: TextInputType.number,
    controller: tec,
  );
}