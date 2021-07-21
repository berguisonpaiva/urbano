import 'dart:convert';

class UserLoginModel {
  String user;
  String senha;
  UserLoginModel({
    required this.user,
    required this.senha,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'senha': senha,
    };
  }

  factory UserLoginModel.fromMap(Map<String, dynamic> map) {
    return UserLoginModel(
      user: map['user'],
      senha: map['senha'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginModel.fromJson(String source) => UserLoginModel.fromMap(json.decode(source));
}
