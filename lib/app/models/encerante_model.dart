import 'dart:convert';

class EnceranteModel {
  String? dataEncerrante;
  String? numeroLinha;
  String? nomeLinha;
  double? valorEspecie;
  int? qtdPagantes;
  double? tarifa;
  double? valorVte;
  double? valorVt;
  double? valorVtAvul;
  double? valorEstCde;
  double? valorBumVta;
  double? valorBumVtm;
  double? valorBumEsm;
  double? valorEstudant;
  double? valorPagord;
  double? valorLbprepg;
  double? valorAenem;
  double? valorJornada;
  int? qtdViagens;
  EnceranteModel({
    this.dataEncerrante,
    this.numeroLinha,
    this.nomeLinha,
    this.valorEspecie,
    this.qtdPagantes,
    this.tarifa,
    this.valorVte,
    this.valorVt,
    this.valorVtAvul,
    this.valorEstCde,
    this.valorBumVta,
    this.valorBumVtm,
    this.valorBumEsm,
    this.valorEstudant,
    this.valorPagord,
    this.valorLbprepg,
    this.valorAenem,
    this.valorJornada,
    this.qtdViagens,
  });

  Map<String, dynamic> toMap() {
    return {
      'dataEncerrante': dataEncerrante,
      'numeroLinha': numeroLinha,
      'nomeLinha': nomeLinha,
      'valorEspecie': valorEspecie,
      'qtdPagantes': qtdPagantes,
      'tarifa': tarifa,
      'valorVte': valorVte,
      'valorVt': valorVt,
      'valorVtAvul': valorVtAvul,
      'valorEstCde': valorEstCde,
      'valorBumVta': valorBumVta,
      'valorBumVtm': valorBumVtm,
      'valorBumEsm': valorBumEsm,
      'valorEstudant': valorEstudant,
      'valorPagord': valorPagord,
      'valorLbprepg': valorLbprepg,
      'valorAenem': valorAenem,
      'valorJornada': valorJornada,
      'qtdViagens': qtdViagens,
    };
  }

  factory EnceranteModel.fromMap(Map<String, dynamic> map) {
    return EnceranteModel(
      dataEncerrante: map['dataEncerrante'],
      numeroLinha: map['numeroLinha'],
      nomeLinha: map['nomeLinha'],
      valorEspecie: map['valorEspecie'],
      qtdPagantes: map['qtdPagantes'],
      tarifa: map['tarifa'],
      valorVte: map['valorVte'],
      valorVt: map['valorVt'],
      valorVtAvul: map['valorVtAvul'],
      valorEstCde: map['valorEstCde'],
      valorBumVta: map['valorBumVta'],
      valorBumVtm: map['valorBumVtm'],
      valorBumEsm: map['valorBumEsm'],
      valorEstudant: map['valorEstudant'],
      valorPagord: map['valorPagord'],
      valorLbprepg: map['valorLbprepg'],
      valorAenem: map['valorAenem'],
      valorJornada: map['valorJornada'],
      qtdViagens: map['qtdViagens'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EnceranteModel.fromJson(String source) => EnceranteModel.fromMap(json.decode(source));
}
