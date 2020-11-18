import 'package:agrotechjp/anuncios.dart';
import 'package:agrotechjp/cadastro.dart';
import 'package:agrotechjp/login.dart';
import 'package:agrotechjp/painelCliente.dart';
import 'package:agrotechjp/painelProdutor.dart';
import 'package:agrotechjp/painelProdutorConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rotas {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/painel-anuncios":
        return MaterialPageRoute(builder: (_) => Anuncios.rota(2));
      case "/painel-produtor":
        return MaterialPageRoute(builder: (_) => PainelProdutor());
      case "/painel-cliente":
        return MaterialPageRoute(builder: (_) => PainelCliente());
      case "/painel-produtor-config":
        return MaterialPageRoute(builder: (_) => PainelProdutorConfig());
      default: _erroRoute();
    }
  }

  static Route<dynamic> _erroRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text("ERRO 404"),
          ),
        );
      },
    );
  }
}
