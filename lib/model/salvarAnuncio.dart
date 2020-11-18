import 'package:cloud_firestore/cloud_firestore.dart';



class salvarAnuncio{
  String _cpfAnuncio;
  String _id;
  String _titulo;
  String _cidade;
  String _categoria;
  String _preco;
  String _descricao;
  List<String> _imagens;


  salvarAnuncio(){
    //acessando o Banco de dados meus anuncios
    //em seguida gerando um documentID e armazenando na variavel id.
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference anuncios = db.collection("meus_anuncios");
    this.id = anuncios.doc().id;

    _imagens = [];
  }



  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "cpfUsuario" : this.cpfAnuncio,
      "id" : this.id,
      "cidade" : this.cidade,
      "categoria": this.categoria,
      "titulo": this.titulo,
      "preco": this.preco,
      "descricao": this.descricao,
      "imagens": this.imagens
    };

    return map;
  }


  String get cpfAnuncio => _cpfAnuncio;

  set cpfAnuncio(String value) {
    _cpfAnuncio = value;
  }

  List<String> get imagens => _imagens;

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  set imagens(List<String> value) {
    _imagens = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }
}