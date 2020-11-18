import 'package:agrotechjp/model/usuario.dart';
import 'package:flutter/material.dart';

class PainelCliente extends StatefulWidget {
  @override
  _PainelClienteState createState() => _PainelClienteState();
}

class _PainelClienteState extends State<PainelCliente> {

  List<String> itensMenu = ["Entrar/Cadastrar","Deslogar"];



  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){
      case "Deslogar" :
        Navigator.pushReplacementNamed(context, "/");
    }
  }
  Future _verificarUsuario(Usuario usuario){
    if (usuario.cpf.isNotEmpty){
      itensMenu =["Entrar/Cadastrar"];
    }
    else{
      itensMenu= ["Deslogar"];
    }
  }
  @override
  void initState(){
    super.initState();
      itensMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncios"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Text("Cliente"),
      ),
    );
  }
}
