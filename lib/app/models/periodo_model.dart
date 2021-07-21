import 'dart:convert';

class PeriodoModel {
  int? id;
String? inicio;
String? fim;
String? desc;
String? status;
String? createdDate;
String? lastUpdateDate;
int? createdBy;
int? lastUpdateBy;
String? calcularEletronico;
String? integracaoAbastecimento;
  PeriodoModel(
   this.id,
   this.inicio,
   this.fim,
  this.desc,
  this.status,
  this.createdDate,
     this.lastUpdateDate,
 this.createdBy,
   this.lastUpdateBy,
     this.calcularEletronico,
   this.integracaoAbastecimento,
  );

      
  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inicio': inicio,
      'fim': fim,
      'desc': desc,
      'status': status,
      'createdDate': createdDate,
      'lastUpdateDate': lastUpdateDate,
      'createdBy': createdBy,
      'lastUpdateBy': lastUpdateBy,
      'calcularEletronico': calcularEletronico,
      'integracaoAbastecimento': integracaoAbastecimento,
    };
  }

  
 

  factory PeriodoModel.fromMap(Map<String, dynamic> map) {
    return PeriodoModel(
      map['id'],
      map['inicio'],
      map['fim'],
      map['desc'],
      map['status'],
      map['createdDate'],
      map['lastUpdateDate'],
      map['createdBy'],
      map['lastUpdateBy'],
      map['calcularEletronico'],
      map['integracaoAbastecimento'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodoModel.fromJson(String source) => PeriodoModel.fromMap(json.decode(source));
}
