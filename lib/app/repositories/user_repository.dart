import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';
import 'package:urbano/app/models/extrato_model.dart';

import 'package:urbano/app/models/periodo_model.dart';
import 'package:urbano/app/models/user_model.dart';

class UserRepository {
  final RestClient restClient;

  UserRepository(this.restClient);

  get http => null;

  Future<UserModel?> login(String usuario, String senha) async {
    try {
      final response = await restClient.post(
        '/webapp/rest/login/',
        {"usuario": usuario, "senha": senha},
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
    } catch (e) {
      print(e);
    }
  }

  Future<List<PeriodoModel>?> periodo(UserModel userModel) async {
    print(userModel.token);
    try {
      final response = await restClient.get<List<PeriodoModel>>(
          '/webapp/rest/list/periodos.json/',
          headers: {"token": '{"token" : "${userModel.token}"}'},
          decoder: (resp) {
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
    } catch (e) {
      print(e);
    }
  }

  Future<List<EnceranteModel>?> dashboard(
      UserModel userModel, int periodo) async {
    print(periodo);
    try {
      final response = await restClient.get<List<EnceranteModel>>(
          '/webapp/rest/dashboardPermissao.json/RelatorioPrestacaoContasCarro.json?periodo=$periodo',
          headers: {
            "token": '{"token" : "${userModel.token}"}'
          }, decoder: (resp) {
        if (resp is List) {
          return resp
              .map<EnceranteModel>((ev) => EnceranteModel.fromMap(ev))
              .toList();
        }
        return <EnceranteModel>[];
      });

      if (response.hasError) {
        print(response.statusCode);
        String message = 'Erro ao buscar dashboard ';

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
    } catch (e) {
      print(e);
    }
  }

  Future<ExtratoModel?> extrato(UserModel userModel, int periodo) async {

    try {
      final response = await restClient.get(
          '/webapp/rest/lancamento.json/desmonstrativoResultadosIndividual.json?escopo=INDIVIDUAL&idPeriodo=$periodo',
          headers: {
            "token": '{"token" : "${userModel.token}"}'
          }, decoder: (resp) {
      
          return ExtratoModel.fromMap(resp);
        
      
      });

      if (response.hasError) {
        print(response.statusCode);
        String message = 'Erro ao buscar dashboard ';

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
      return response.body;
    } catch (e) {
      print(e);
    }
  }
 
}
