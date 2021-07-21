import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';
import 'package:urbano/app/models/periodo_model.dart';

import 'package:urbano/app/models/user_model.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';
import 'package:urbano/app/repositories/user_repository.dart';

class HomeController extends GetxController {
  final UserRepository _repository;
  final usuario =
      UserModel(grupo: '', token: '', usuario: '', permissao: '').obs;
  final periodo = <PeriodoModel>[].obs;
  final encerrante = <EnceranteModel>[].obs;
  HomeController(
    this._repository,
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    final sp = await SharedPreferences.getInstance();
    var user = (UserModel.fromJson(sp.getString('user')!));
    usuario(user);

    periodoFindall();
  }

  Future<void> periodoFindall() async {
    try {
      final resp = await _repository.periodo(usuario.value);

      periodo(resp);
    } on RestClientException catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: "Erro!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> dashbord(int periodo) async {
    try {
      final resp = await _repository.dashboard(usuario.value, periodo);
      
    } on RestClientException catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: "Erro!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> sair() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    Get.offAllNamed(SplashPage.ROUTE_PAGE);
  }
}
