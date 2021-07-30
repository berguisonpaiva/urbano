import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/helpers/loader_mixin.dart';
import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';
import 'package:urbano/app/models/periodo_model.dart';

import 'package:urbano/app/models/user_model.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';
import 'package:urbano/app/repositories/user_repository.dart';

class HomeController extends GetxController with StateMixin, LoaderMixin {
  final UserRepository _repository;
  final loader = false.obs;
  final usuario =
      UserModel(grupo: '', token: '', usuario: '', permissao: '').obs;
  final periodo = <PeriodoModel>[].obs;
  final encerrante = <EnceranteModel>[].obs;
  final selectIdPeriodo = 0.obs;
  final selectTituloPeriodo = ('').obs;
  final valorVTE = 0.0.obs;
  final valorEspecie = 0.0.obs;
  final valorTotal = 0.0.obs;
  HomeController(
    this._repository,
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(loader);
    final sp = await SharedPreferences.getInstance();
    var user = (UserModel.fromJson(sp.getString('user')!));
    usuario(user);

    selectIdPeriodo(usuario.value.periodo!.id);
    selectTituloPeriodo(usuario.value.periodo!.desc);
    print(selectIdPeriodo);
    periodoFindall();
    dashbord();
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

  Future<void> dashbord() async {
    valorVTE(0.0);
    valorEspecie(0.0);
    valorTotal(0.0);
      change([], status: RxStatus.loading());
    try {
      final resp =
          await _repository.dashboard(usuario.value, selectIdPeriodo.value);

      encerrante(resp);
      encerrante.forEach((element) {
        valorVTE(valorVTE.value + element.valorVte!);
        valorEspecie(valorEspecie.value + element.valorEspecie!);
      });
      valorTotal(valorVTE.value + valorEspecie.value);
      change(encerrante, status: RxStatus.success());
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
