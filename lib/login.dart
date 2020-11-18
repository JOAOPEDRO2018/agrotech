import 'package:agrotechjp/anuncios.dart';
import 'package:agrotechjp/model/usuario.dart';
import 'package:agrotechjp/rotas/route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _carregando = false;
  String _msgErro = "";
  Usuario usuario;


  _validarCampos() {
    String cpf = _controllerCpf.text;
    String senha = _controllerSenha.text;
    String cpfForm = CPF.format(cpf);

    if (cpfForm.isNotEmpty && CPF.isValid(cpfForm)) {
      if (senha.isNotEmpty && senha.length >= 6) {
        usuario = Usuario();
        usuario.cpf = cpfForm;
        usuario.senha = senha;
        _logarUsuario(usuario);
      } else {
        setState(() {
          _msgErro = "Senha incorreta!";
        });
      }
    } else {
      setState(() {
        _msgErro = "CPF incorreto!";
      });
    }
  }

  _logarUsuario(Usuario usuario) async {
    String cpf = _controllerCpf.text;
    String cpfForm = CPF.format(cpf);
    setState(() {
      _carregando = true;
    });
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    //recupera os dados
    QuerySnapshot snapshot = await db.collection("usuarios").get();

    snapshot.docs.forEach((d) async {
      print(d.id);
      Map<String, dynamic> dados = d.data();
      String cpfBanco = await dados["cpf"];
      String senhaBd = dados["senha"];
      String tipoUsuario = dados["tipoUsuario"];
      //String id = dados[d.id];
      //print("id do usu: "+await dados[d.id]);

      if (cpfBanco == usuario.cpf && senhaBd == _controllerSenha.text) {
        switch (tipoUsuario) {
          case "produtor":
            Navigator.pushReplacementNamed(context, "/painel-produtor");
            break;
          case "cliente":

            print("cpflogin:"+cpfForm);
            Navigator.pushReplacementNamed(context, "/painel-produtor");
            break;
        }
        _carregando = false;
      } else {
        _msgErro = "Erro ao autenticar usuário, verifique o CPF e senha";
        _carregando = false;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgroTech"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "image/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
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
                Padding(padding: EdgeInsets.only(top: 15)),
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
                RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      _validarCampos();
                    }),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      child: Text(
                        "Cadastre-se",
                        style:
                            TextStyle(color: Colors.orangeAccent, fontSize: 20),
                      ),
                      onTap: () => Navigator.pushNamed(context, "/cadastro"),
                    ),
                  ),
                ),
                _carregando
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white70,
                        ),
                      )
                    : Center(
                        child: Text(
                          _msgErro,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
