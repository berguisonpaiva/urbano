import 'dart:convert';

class PeriodoModel {
  int id;
  String inicio;
  String fim;
  String desc;
  String status;
  String createdDate;
  String lastUpdateDate;
  int createdBy;
  int lastUpdateBy;
  String calcularEletronico;
  String integracaoAbastecimento;
  PeriodoModel({
    required this.id,
    required this.inicio,
    required this.fim,
    required this.desc,
    required this.status,
    required this.createdDate,
    required this.lastUpdateDate,
    required this.createdBy,
    required this.lastUpdateBy,
    required this.calcularEletronico,
    required this.integracaoAbastecimento,
  });

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
      id: map['id'] ?? '',
      inicio: map['inicio'] ?? '',
      fim: map['fim'] ?? '',
      desc: map['desc'] ?? '',
      status: map['status'] ?? '',
      createdDate: map['createdDate'] ?? '',
      lastUpdateDate: map['lastUpdateDate'] ?? '',
      createdBy: map['createdBy'] ?? '',
      lastUpdateBy: map['lastUpdateBy'] ?? '',
      calcularEletronico: map['calcularEletronico'] ?? '',
      integracaoAbastecimento: map['integracaoAbastecimento'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodoModel.fromJson(String source) =>
      PeriodoModel.fromMap(json.decode(source));
}
