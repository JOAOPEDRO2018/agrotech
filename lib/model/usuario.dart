class Usuario {
  String _nome;
  String _cpf;
  String _senha;
  String _tipoUsuario;

  Map<String, dynamic> toMap() {
    Map map = {
      "nome": this._nome,
      "cpf": this._cpf,
      "tipoUsuario": this._tipoUsuario
    };
    return map;
  }

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
