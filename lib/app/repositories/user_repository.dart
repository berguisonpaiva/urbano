import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';

import 'package:urbano/app/models/periodo_model.dart';
import 'package:urbano/app/models/user_model.dart';

class UserRepository {
  final RestClient restClient;

  UserRepository(this.restClient);

  get http => null;

  Future<UserModel?> login(String usuario, String password) async {
    final response = await restClient.post(
      '/rest/login',
      {'usuario': usuario, 'senha': password},
      decoder: (resp) {
        if (resp != '') {
          return UserModel.fromMap(resp);
        }
      },
    );
    if (response.hasError) {
      String message = 'Erro ao autenticar usuário ';

      if (response.statusCode == 403) {
        message = 'Usuário e Senha Inválidos';
      }
      throw RestClientException(message);
    }
    return response.body;
  }

  Future<List<PeriodoModel>> periodo(UserModel userModel) async {
    print(userModel.token);
    final response = await restClient.get<List<PeriodoModel>>(
        '/rest/list/periodos.json/',
        headers: {"token": userModel.token}, decoder: (resp) {
      if (resp is List) {
        return resp
            .map<PeriodoModel>((ev) => PeriodoModel.fromMap(ev))
            .toList();
      }
      return <PeriodoModel>[];
    });
    if (response.hasError) {
      print(response.statusCode);
      String message = 'Erro ao buscar periodo ';

      if (response.statusCode == 403) {
        message = 'Usuario não autenticado';
      }
      if (response.statusCode == 404) {
        message = 'Não contem periodo';
      }
      if (response.statusCode == 400) {
        message = 'Dados não validos';
      }
      throw RestClientException(message);
    }

    return response.body ?? <PeriodoModel>[];
  }

  Future<List<EnceranteModel>> dashboard(
      UserModel userModel, int periodo) async {
    final response = await restClient.get<List<EnceranteModel>>(
        '/rest/dashboardPermissao.json/RelatorioPrestacaoContasCarro.json?periodo=$periodo',
        headers: {"token": userModel.token}, decoder: (resp) {
     
      return <EnceranteModel>[];
    });
  
    if (response.hasError) {
      print(response.statusCode);
      String message = 'Erro ao buscar periodo ';

      if (response.statusCode == 403) {
        message = 'Usuario não autenticado';
      }
      if (response.statusCode == 404) {
        message = 'Não contem periodo';
      }
      if (response.statusCode == 400) {
        message = 'Dados não validos';
      }
      throw RestClientException(message);
    }

    return response.body ?? <EnceranteModel>[];
  }
}
