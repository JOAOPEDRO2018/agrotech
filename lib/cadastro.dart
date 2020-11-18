import 'package:agrotechjp/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completo");
      setState(() {
        build(context);
      });
    });
  }

  bool _tipoCadastro = false;
  String _msgErro = "";

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String verificarUsuario(bool tipoUsuario) {
    return tipoUsuario ? "produtor" : "cliente";
  }

  _validarCampos() {
    String nome = _controllerNome.text;
    String cpf = _controllerCpf.text;
    String senha = _controllerSenha.text;
//prot1045472
//numero ordem 40213073
//codposta: 1529815069
    if (nome.isNotEmpty && nome.length >= 3) {
      String cpfForm = CPF.format(cpf);
      if (cpfForm.isNotEmpty && CPF.isValid(cpfForm)) {
        if (senha.isNotEmpty && senha.length >= 6) {
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.cpf = cpfForm;
          usuario.senha = senha;
          usuario.tipoUsuario = verificarUsuario(_tipoCadastro);

          _cadastrarUsuario(usuario);
        } else {
          setState(() {
            _msgErro = "A senha deve ter no mínimo 6 caracteres";
          });
        }
      } else {
        setState(() {
          _msgErro = "Digite um CPF válido";
        });
      }
    } else {
      setState(() {
        _msgErro = "Preencha com um nome de pelo menos três (3) carateres";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) {
    // ignore: deprecated_member_use
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("usuarios").doc().set({
      "nome": usuario.nome,
      "cpf": usuario.cpf,
      "senha": usuario.senha,
      "tipoUsuario": usuario.tipoUsuario
    });



    switch (usuario.tipoUsuario) {
      case "produtor":
        Navigator.pushNamedAndRemoveUntil(
            context, "/painel-produtor", (_) => false);
        break;
      case "cliente":
        Navigator.pushNamedAndRemoveUntil(
            context, "/painel-cliente", (_) => false);
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent, accentColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Seu nome ou apelido social: ",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7))),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  TextField(
                    controller: _controllerCpf,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "CPF: ",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7))),
                  ),
                  TextField(
                    controller: _controllerSenha,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Senha: ",
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cliente"),
                      Switch(
                        value: _tipoCadastro,
                        onChanged: (bool valor) {
                          setState(() {
                            _tipoCadastro = valor;
                          });
                        },
                      ),
                      Text("Produtor"),
                    ],
                  ),
                  RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.orangeAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _validarCampos();
                      }),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        _msgErro,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
