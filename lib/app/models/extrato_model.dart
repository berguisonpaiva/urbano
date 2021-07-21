import 'dart:convert';

class ExtratoModel {
  List<Lancamento>? lancamento;
  double? resultadoPerido;
  double? resultadoPeridoDebitos;
  double? resultadoPeridoCreditos;
  double? saldoAcumulado;
  double? saldoAcumuladoDebitos;
  double? saldoAcumuladocreditos;
  ExtratoModel(
    this.lancamento,
    this.resultadoPerido,
    this.resultadoPeridoDebitos,
    this.resultadoPeridoCreditos,
    this.saldoAcumulado,
    this.saldoAcumuladoDebitos,
    this.saldoAcumuladocreditos,
  );


  Map<String, dynamic> toMap() {
    return {
      'lancamento': lancamento?.map((x) => x.toMap()).toList(),
      'resultadoPerido': resultadoPerido,
      'resultadoPeridoDebitos': resultadoPeridoDebitos,
      'resultadoPeridoCreditos': resultadoPeridoCreditos,
      'saldoAcumulado': saldoAcumulado,
      'saldoAcumuladoDebitos': saldoAcumuladoDebitos,
      'saldoAcumuladocreditos': saldoAcumuladocreditos,
    };
  }

  

  factory ExtratoModel.fromMap(Map<String, dynamic> map) {
    return ExtratoModel(
      List<Lancamento>.from(map['lancamento']?.map((x) => Lancamento.fromMap(x))),
      map['resultadoPerido'],
      map['resultadoPeridoDebitos'],
      map['resultadoPeridoCreditos'],
      map['saldoAcumulado'],
      map['saldoAcumuladoDebitos'],
      map['saldoAcumuladocreditos'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtratoModel.fromJson(String source) => ExtratoModel.fromMap(json.decode(source));
}

class Lancamento {
  LancamentoTipo? lancamentoTipo;
  String lancamentoTipoNome;
  String debitoOuCredito;
  double valor;
  String escopo;
  String observacao;
  int id;
  int numParcela;
  Parcela parcela;
  String data;
  String debitar;
  double totalDebito;
  double totalCredito;
  Lancamento({
    required this.lancamentoTipoNome,
    required this.debitoOuCredito,
    required this.valor,
    required this.escopo,
    required this.observacao,
    required this.id,
    required this.numParcela,
    required this.parcela,
    required this.data,
    required this.debitar,
    required this.totalDebito,
    required this.totalCredito,
  });

 

  Map<String, dynamic> toMap() {
    return {
      'lancamentoTipoNome': lancamentoTipoNome,
      'debitoOuCredito': debitoOuCredito,
      'valor': valor,
      'escopo': escopo,
      'observacao': observacao,
      'id': id,
      'numParcela': numParcela,
      'parcela': parcela.toMap(),
      'data': data,
      'debitar': debitar,
      'totalDebito': totalDebito,
      'totalCredito': totalCredito,
    };
  }

  factory Lancamento.fromMap(Map<String, dynamic> map) {
    return Lancamento(
      lancamentoTipoNome: map['lancamentoTipoNome'],
      debitoOuCredito: map['debitoOuCredito'],
      valor: map['valor'],
      escopo: map['escopo'],
      observacao: map['observacao'],
      id: map['id'],
      numParcela: map['numParcela'],
      parcela: Parcela.fromMap(map['parcela']),
      data: map['data'],
      debitar: map['debitar'],
      totalDebito: map['totalDebito'],
      totalCredito: map['totalCredito'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Lancamento.fromJson(String source) => Lancamento.fromMap(json.decode(source));
}

class LancamentoTipo {
  Tipo tipo;
  String nome;
  String origem;
  int id;
  Tipo tipoValor;
  LancamentoTipo({
    required this.tipo,
    required this.nome,
    required this.origem,
    required this.id,
    required this.tipoValor,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo.toMap(),
      'nome': nome,
      'origem': origem,
      'id': id,
      'tipoValor': tipoValor.toMap(),
    };
  }

  factory LancamentoTipo.fromMap(Map<String, dynamic> map) {
    return LancamentoTipo(
      tipo: Tipo.fromMap(map['tipo']),
      nome: map['nome'],
      origem: map['origem'],
      id: map['id'],
      tipoValor: Tipo.fromMap(map['tipoValor']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LancamentoTipo.fromJson(String source) => LancamentoTipo.fromMap(json.decode(source));
}

class Tipo {
  String id;
  String nome;
  Tipo({
    required this.id,
    required this.nome,
  });



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Tipo.fromMap(Map<String, dynamic> map) {
    return Tipo(
      id: map['id'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tipo.fromJson(String source) => Tipo.fromMap(json.decode(source));
}

class Parcela {
  int id;
  int qtd;
  Parcela({
    required this.id,
    required this.qtd,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qtd': qtd,
    };
  }

  factory Parcela.fromMap(Map<String, dynamic> map) {
    return Parcela(
      id: map['id'],
      qtd: map['qtd'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Parcela.fromJson(String source) => Parcela.fromMap(json.decode(source));
}
