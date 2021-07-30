import 'dart:convert';

class LancamentoModel {
  int? id;
  LancamentoTipo lancamentoTipo;
  String lancamentoTipoNome;
  String? debitoOuCredito;
  double valor;
  String? escopo;
  int? numParcela;
  Parcela? parcela;
  String? data;
  String? debitar;
  LancamentoModel({
    this.id,
 required this.lancamentoTipo,
 required this.lancamentoTipoNome,
  this.debitoOuCredito,
 required this.valor,
 this.escopo,
    this.numParcela,
    this.parcela,
   this.data,
  this.debitar,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lancamentoTipo': lancamentoTipo.toMap(),
      'lancamentoTipoNome': lancamentoTipoNome,
      'debitoOuCredito': debitoOuCredito,
      'valor': valor,
      'escopo': escopo,
      'numParcela': numParcela,
      'parcela': parcela?.toMap(),
      'data': data,
      'debitar': debitar,
    };
  }

  factory LancamentoModel.fromMap(Map<String, dynamic> map) {
    return LancamentoModel(
      id: map['id']??0,
      lancamentoTipo: LancamentoTipo.fromMap(map['lancamentoTipo']??{}),
      lancamentoTipoNome: map['lancamentoTipoNome']??'',
      debitoOuCredito: map['debitoOuCredito']??'',
      valor: map['valor']??0.0,
      escopo: map['escopo']??'',
      numParcela: map['numParcela']??0,
      parcela: Parcela.fromMap(map['parcela']??{}),
      data: map['data']??'',
      debitar: map['debitar']??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory LancamentoModel.fromJson(String source) => LancamentoModel.fromMap(json.decode(source));
}

class LancamentoTipo {
  int? id;
  Tipo? tipo;
  String? nome;
  String? origem;
  Tipo? tipoValor;
  LancamentoTipo({
    this.id,
  this.tipo,
   this.nome,
     this.origem,
    this.tipoValor,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo?.toMap(),
      'nome': nome,
      'origem': origem,
      'tipoValor': tipoValor?.toMap(),
    };
  }

  factory LancamentoTipo.fromMap(Map<String, dynamic> map) {
    return LancamentoTipo(
      id: map['id']??0,
      tipo: Tipo.fromMap(map['tipo']??{}),
      nome: map['nome']??'',
      origem: map['origem']??'',
      tipoValor: Tipo.fromMap(map['tipoValor']??{}),
    );
  }

  String toJson() => json.encode(toMap());

  factory LancamentoTipo.fromJson(String source) => LancamentoTipo.fromMap(json.decode(source));
}

class Tipo {
  String? id;
  String? nome;
  Tipo({
   this.id,
 this.nome,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Tipo.fromMap(Map<String, dynamic> map) {
    return Tipo(
      id: map['id']??'',
      nome: map['nome']??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tipo.fromJson(String source) => Tipo.fromMap(json.decode(source));
}

class Parcela {
  int? id;
  int? qtd;
  Parcela({
   this.id,
   this.qtd,
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
