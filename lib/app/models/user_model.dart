
import 'dart:convert';

import 'package:urbano/app/models/periodo_model.dart';

class UserModel {
   String token;
  String permissao;
  String usuario;
  String grupo;
  PeriodoModel? periodo;
  UserModel({
    required this.token,
    required this.permissao,
    required this.usuario,
    required this.grupo,
     this.periodo,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'permissao': permissao,
      'usuario': usuario,
      'grupo': grupo,
      'periodo': periodo?.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token']??'',
      permissao: map['permissao']??'',
      usuario: map['usuario']??'',
      grupo: map['grupo']??'',
      periodo: PeriodoModel.fromMap(map['periodo']??''),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
