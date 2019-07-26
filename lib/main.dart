import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const request = "http://api.hgbrasil.com/finance?formt=json&key=216690bb";

void main() async {

  http.Response response = await http.get(request);
  //add um map ao lado do outro para ir acessando as chaves
  print(json.decode(response.body)["results"]["currencies"]["EUR"]);

  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();

  }
}

