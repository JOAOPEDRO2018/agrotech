
import 'package:flutter/material.dart';

class TelaProdutorTest extends StatefulWidget {
  @override
  _TelaProdutorTestState createState() => _TelaProdutorTestState();
}

class _TelaProdutorTestState extends State<TelaProdutorTest> {
  @override

  Container MyArticles (String imageVal, String prod, String preco){
    return Container(
      width: 160,
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
              children: [
                MyArticles("image/cenoura.jpg","produto" , "RS88.88"),
                MyArticles("image/cenoura.jpg","produto" , "RS88.88"),
                MyArticles("image/cenoura.jpg","produto" , "RS88.88"),
                MyArticles("image/cenoura.jpg","produto" , "RS88.88"),
                MyArticles("image/cenoura.jpg","produto" , "RS88.88"),
                MyArticles("image/cenoura.jpg","produto" , "RS88.88")
              ],
          ),
        ),
      ),
    );
  }
}
