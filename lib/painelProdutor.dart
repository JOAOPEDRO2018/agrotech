import 'package:agrotechjp/model/itemAnuncios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PainelProdutor extends StatefulWidget {
  @override
  _PainelProdutorState createState() => _PainelProdutorState();
}

class _PainelProdutorState extends State<PainelProdutor> {
  final String url =
      'https://www.speedrun.com/themes/miner_ultra_adventures/cover-256.png?version=';
  List<String> produtos = ["cenoura", "cenoura", "cenoura"];
  List<String> preco = ["RS: 00,00/Kg", "RS: 00,00/Kg", "RS: 00,00/Kg"];

  Container MyArticles(String imageVal, String prod, String preco) {
    return Container(
      width: 120,
      child: Card(
        child: Wrap(
          children: [
            Image.asset(imageVal),
            ListTile(
              title: Text(prod),
              subtitle: Text(preco),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          bottomNavigationBar: BottomNavyBar(),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //dados do vendedor
                Container(
                  padding: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.orange[800],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  //child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "ID: 14552566",
                        style: TextStyle(color: Colors.white70, height: 3),
                      ),
                      Text("Anderson Mineirinho",
                          style: TextStyle(
                              color: Colors.white, fontSize: 24, height: 2)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Produtos\nCadastrados",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "5",
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 2,
                                    fontSize: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                          ClipOval(
                              child: Image(
                            width: 100,
                            height: 130,
                            image: NetworkImage(url),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(children: <Widget>[
                              Text(
                                "Mensagens\nPendentes",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text("3",
                                  style: TextStyle(
                                      color: Colors.white,
                                      height: 2,
                                      fontSize: 30))
                            ]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 170, top: 10, bottom: 10),
                      child: Text(
                        "Produtos mais vendidos",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 17),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 145,
                      child:   GestureDetector(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            MyArticles(
                                "image/cenoura.jpg", "produto", "RS88.88"),


                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 220, bottom: 10),
                          child: Text(
                            "Últimos produtos",
                            style: TextStyle(
                                color: Colors.deepOrange, fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 150,
                        child:   GestureDetector(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              MyArticles(
                                  "image/cenoura.jpg", "produto", "RS88.88"),


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }
}

class BottomNavyBar extends StatefulWidget {
  @override
  _BottomNavyBarState createState() => _BottomNavyBarState();
}

class _BottomNavyBarState extends State<BottomNavyBar> {
  int index = 0;

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
  _itemSelecionado(int item){
    setState(() {
      index = item;
    });
    switch(item){
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
