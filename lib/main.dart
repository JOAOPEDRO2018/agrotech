import 'package:agrotechjp/cadastro.dart';
import 'package:agrotechjp/login.dart';
import 'package:agrotechjp/painelProdutor.dart';
import 'package:agrotechjp/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'rotas/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "AgroTech",
    home: Login(),
    initialRoute: "/",
    onGenerateRoute: Rotas.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
