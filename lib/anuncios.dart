import 'dart:io';

import 'package:agrotechjp/InputCustomizado.dart';
import 'package:agrotechjp/login.dart';
import 'package:agrotechjp/model/salvarAnuncio.dart';
import 'package:agrotechjp/model/usuario.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';

class Anuncios extends StatefulWidget {
  int valor;
  Anuncios.rota(this.valor);


  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  final _formKey = GlobalKey<FormState>();
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaItensCidades = List();
  List<DropdownMenuItem<String>> _listaItensCategorias = List();
  BuildContext _dialogContext;
  List<String> _cidades = [
    "São Luís",
    'Imperatriz ',
    'São José de Ribamar',
    'Timon',
    'Caxias'
  ];
  List<String> _categoria = [
    "Frutas",
    "Vegetais",
    "Carne",
    "Laticínios",
    "Grãos",
    "Legumes",
    "Ovos"
  ];
  salvarAnuncio _anuncio;



  @override
  void initState() {
    super.initState();
    _carregarItensDrop();
    _anuncio = salvarAnuncio();
  }




  _carregarItensDrop() {

    for (var cidades in _cidades) {
      _listaItensCidades
          .add(DropdownMenuItem(child: Text(cidades), value: cidades));
    }
    for (var categoria in _categoria) {
      _listaItensCategorias
          .add(DropdownMenuItem(child: Text(categoria), value: categoria));
    }
  }



  _barra() {
    // referente a barra de seleção que aparece quando se clica para adicionar imagens
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 125,
            child: Container(
              child: Container(
                child: _buildBottom(),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )),
              ),
            ),
          );
        });
  }

  Column _buildBottom() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text("Camera"),
          onTap: () {
            _selecionarImage(true);
          },
        ),
        ListTile(
          leading: Icon(Icons.collections),
          title: Text("Galeria"),
          onTap: () {
            _selecionarImage(false);
          },
        ),
      ],
    );
  }

  _selecionarImage(bool opcoes) async {
    if (opcoes) {
      File imagem = await ImagePicker.pickImage(source: ImageSource.camera);
      if (imagem != null) {
        setState(() {
          _listaImagens.add(imagem);
        });
      }
    }
    if (opcoes == false) {
      File imagem = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imagem != null) {
        setState(() {
          _listaImagens.add(imagem);
        });
      }
    }
  }

  _carregando(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anuncio. . . ")
              ],
            ),
          );
        });
  }

  _salvarAnuncio() async{
    _carregando(_dialogContext);
    await _uploadImagens();


    //salvar os dados do anuncio
    FirebaseFirestore db = FirebaseFirestore.instance;
    //cria uma nova coleção no id do usuario logado
    QuerySnapshot snapshot = await db.collection("usuarios").get();
    snapshot.docs.forEach((d) async {
      print("Id do usuario:"+d.id);
      Map<String, dynamic> dados = d.data();

     // cpfBanco = await dados["cpf"];
     // print("cpffffff:"+cpfBanco);

      /*
      if(cpfBanco == _usuario.cpf){
        _anuncio.cpfAnuncio = _usuario.cpf;
      }
      else{
        print("cpf errado");
      }
*/
      db.collection("usuarios")
          .doc(d.id)
          .collection("anuncios")
          .doc(_anuncio.id)
          .set(_anuncio.toMap()).then((value) {

      });


      String tipoUsuario = dados["tipoUsuario"];
      print("tipo do usuario:"+tipoUsuario.toString());
      switch (tipoUsuario) {
        case "produtor":
          Navigator.pushReplacementNamed(context, "/painel-produtor");
          break;
        case "cliente":
          Navigator.pushReplacementNamed(context, "/painel-produtor");
          break;
      }
    });





  }
  Future _uploadImagens() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens){
      //gera um nome unico para a  imagem
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem);
      print("imagem sendo enviada");
      //
      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.imagens.add(url.toString());


    }
    Navigator.pop(_dialogContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
        backgroundColor: Colors.orange[700],
      ),
      bottomNavigationBar: BottomNavyBar(widget.valor),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //area de imagens
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens.length == 0) {
                      return "Coloque uma imagem";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        _barra();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                  color: Colors.grey[100]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      //função que exclui imagem
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  Image.file(_listaImagens[
                                                  indice]),
                                                  FlatButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _listaImagens
                                                            .removeAt(
                                                            indice);
                                                        Navigator.of(
                                                            context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text("Excluir"),
                                                    textColor: Colors.red,
                                                  )
                                                ],
                                              ),
                                            ));
                                      },
                                      child: CircleAvatar(
                                        //metodo para colocar a imagem na lista
                                        radius: 50,
                                        backgroundImage:
                                        FileImage(_listaImagens[indice]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.2),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "${state.errorText}",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  //categorias do novo anuncio
                  children: [
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: DropdownButtonFormField(
                              hint: Text("Cidades"),
                              onSaved: (cidade){
                                _anuncio.cidade = cidade;
                              },
                              items: _listaItensCidades,
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                    .valido(valor);
                              },
                              onChanged: (valor) {
                                print(valor);
                              }),
                        )),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: DropdownButtonFormField(
                              hint: Text("Categoria"),
                              onSaved: (categoria){
                                _anuncio.categoria = categoria;
                              },
                              items: _listaItensCategorias,
                              validator: (valor) {
                                return Validador()
                                    .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                    .valido(valor);
                              },
                              onChanged: (valor) {
                                print(valor);
                              }),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  child: InputCustomizado(
                    hint: "Título",
                    onSaved: (titulo){
                      _anuncio.titulo = titulo;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                    onSaved: (preco){
                      _anuncio.preco = preco;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 5),
                  child: InputCustomizado(
                    hint: "Descrição",
                    onSaved: (descricao){
                      _anuncio.descricao = descricao;
                    },
                    maxLines: null,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                RaisedButton(
                  //Botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Publicar",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                  ),
                  color: Colors.white70,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  onPressed: () {
                    if (_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      _dialogContext = context;
                      _salvarAnuncio();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavyBar extends StatefulWidget {
  int valor;
  BottomNavyBar(this.valor);

  @override
  _BottomNavyBarState createState() => _BottomNavyBarState();
}

class _BottomNavyBarState extends State<BottomNavyBar> {
  int index = 2;

  List<NavigationItem> itens = [
    NavigationItem(
        Icon(
          Icons.perm_identity,
          size: 35,
        ),
        Text("Perfil")),
    NavigationItem(
        Icon(
          Icons.card_giftcard,
          size: 35,
        ),
        Text("Produtos")),
    NavigationItem(
        Icon(
          Icons.add_box,
          size: 35,
        ),
        Text("Adicionar\nProdutos")),
    NavigationItem(
        Icon(
          Icons.chat_bubble_outline,
          size: 35,
        ),
        Text("Chat")),
    NavigationItem(
        Icon(
          Icons.settings,
          size: 35,
        ),
        Text("Configurações")),
  ];
  Widget _item(NavigationItem item, bool Selecionado) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 240),
      height: 50,
      width: Selecionado ? 140 : 50,
      padding: EdgeInsets.only(left: 8, right: 4),
      decoration: Selecionado
          ? BoxDecoration(
          color: Colors.orange[700],
          borderRadius: BorderRadius.all(Radius.circular(100)))
          : null,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                    size: 15, color: Selecionado ? Colors.white : Colors.black),
                child: item.icon,
              ),
              Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Selecionado ? item.title : Container())
            ],
          )
        ],
      ),
    );
  }

  _itemSelecionado(int item) {
    setState(() {
      index = item;
    });
    switch (item) {
      case 0:
        Navigator.pushReplacementNamed(context, "/painel-produtor");
        break;
      case 2:
        Navigator.pushReplacementNamed(context, "/painel-anuncios");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.deepOrange, blurRadius: 1, spreadRadius: 1)
      ]),
      height: 67,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: itens.map((item) {
          var itemIndex = itens.indexOf(item);
          return GestureDetector(
            onTap: () {
              _itemSelecionado(itemIndex);
            },
            child: _item(item, index == itemIndex),
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final Icon icon;
  final Text title;

  NavigationItem(this.icon, this.title);
}
