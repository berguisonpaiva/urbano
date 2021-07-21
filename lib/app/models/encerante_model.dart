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
  EnceranteModel(
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
  );

  
 

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
      map['dataEncerrante'],
      map['numeroLinha'],
      map['nomeLinha'],
      map['valorEspecie'],
      map['qtdPagantes'],
      map['tarifa'],
      map['valorVte'],
      map['valorVt'],
      map['valorVtAvul'],
      map['valorEstCde'],
      map['valorBumVta'],
      map['valorBumVtm'],
      map['valorBumEsm'],
      map['valorEstudant'],
      map['valorPagord'],
      map['valorLbprepg'],
      map['valorAenem'],
      map['valorJornada'],
      map['qtdViagens'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EnceranteModel.fromJson(String source) => EnceranteModel.fromMap(jsonDecode(source));

  
}
