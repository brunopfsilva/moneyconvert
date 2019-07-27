import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//constante
const request = "http://api.hgbrasil.com/finance?formt=json&key=216690bb";


Future<Map> getData() async {
  http.Response response = await http.get(request);
  //add um map ao lado do outro para ir acessando as chaves
  return json.decode(response.body);
  //return (json.decode(response.body)["results"]["currencies"]["EUR"]);
}

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  double euro;
  double dolar;
  //controllers edit text
  final realeditControler = TextEditingController();
  final euroeditControler = TextEditingController();
  final dolareditControler = TextEditingController();

  //text change edittext

  void _realchanged (String text){
  double real = double.parse(text);
  dolareditControler.text = (real/dolar).toStringAsPrecision(4);
  euroeditControler.text = (real/euro).toStringAsPrecision(4);
  }

  void _eurochanged (String text){
    double euro = double.parse(text);
    realeditControler.text = (euro * this.euro).toStringAsPrecision(4);
    dolareditControler.text = (euro * this.euro / dolar).toStringAsPrecision(4);




  }

  void _dolarchanged (String text){
    double dolar = double.parse(text);
    // this.euro; pega a variavel acima nao a de dentro da funcao
    realeditControler.text = (dolar * this.dolar).toStringAsPrecision(4);
    euroeditControler.text = (dolar * this.dolar / euro).toStringAsPrecision(4);

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("€\ Conversor \€"),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<Map>(
            //esqueci de colocar o           future: getData(), ~~
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      "Carregando dados",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "erro ao carregar dados :(",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 99,
                            color: Colors.lightBlue,
                          ),
                          buildTextField("Real", "R\$",realeditControler,_realchanged),
                          Divider(),
                          buildTextField("Euro", "€",euroeditControler,_eurochanged),
                          //espaço entre os componentes
                          Divider(),
                          buildTextField("Dolar", "\$",dolareditControler,_dolarchanged),
                        ],
                      ),
                    );
                  }
                  break;
              }
            }),
      ),
    );
  }

  Widget buildTextField(String label, String prefix, TextEditingController ed ,Function functionTextChange) {
    return TextField(
      controller: ed,
      decoration: InputDecoration(
          labelText: label, border: OutlineInputBorder(), prefixText: prefix),
      style: TextStyle(color: Colors.lightBlue, fontSize: 20),
      //chama a função sempre que o texto muda
      onChanged: functionTextChange,
      textAlign: TextAlign.center,
      //so aceita numeros
      keyboardType: TextInputType.number,
    );
  }
}
