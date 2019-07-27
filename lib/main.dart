import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//constante
const request = "http://api.hgbrasil.com/finance?formt=json&key=216690bb";

double euro;
double dolar;

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
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
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
                          TextField(
                            decoration: InputDecoration(labelText: "Reais",border: OutlineInputBorder(),prefixText: "R\$"),
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 20),textAlign: TextAlign.center,
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(labelText: "Euros",border: OutlineInputBorder(),prefixText: "€"),
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 20),textAlign: TextAlign.center,
                          ),
                          //espaço entre os componentes
                          Divider(),
                          TextField(
                            decoration: InputDecoration(labelText: "Resultado",border: OutlineInputBorder(),prefixText: "="),
                            style: TextStyle(
                                color: Colors.lightBlue, fontSize: 20),textAlign: TextAlign.center,
                          ),
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
}
