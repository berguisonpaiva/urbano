import 'dart:convert';

import 'package:urbano/app/models/lancamento_model.dart';

class ExtratoModel {
List<LancamentoModel>? lancamento;
  double resultadoPerido;
  double resultadoPeridoDebitos;
  double resultadoPeridoCreditos;
  double saldoAcumulado;
  double saldoAcumuladoDebitos;
  double saldoAcumuladocreditos;
  ExtratoModel({
    this.lancamento,
    required this.resultadoPerido,
    required this.resultadoPeridoDebitos,
    required this.resultadoPeridoCreditos,
    required this.saldoAcumulado,
    required this.saldoAcumuladoDebitos,
    required this.saldoAcumuladocreditos,
  });
  
 

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
      lancamento: List<LancamentoModel>.from(map['lancamento']?.map((x) => LancamentoModel.fromMap(x))??[]),
      resultadoPerido: map['resultadoPerido'],
      resultadoPeridoDebitos: map['resultadoPeridoDebitos'],
      resultadoPeridoCreditos: map['resultadoPeridoCreditos'],
      saldoAcumulado: map['saldoAcumulado'],
      saldoAcumuladoDebitos: map['saldoAcumuladoDebitos'],
      saldoAcumuladocreditos: map['saldoAcumuladocreditos'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtratoModel.fromJson(String source) =>
      ExtratoModel.fromMap(json.decode(source));
}




