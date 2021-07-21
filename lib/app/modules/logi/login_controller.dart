import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/helpers/loader_mixin.dart';
import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';
import 'package:urbano/app/repositories/user_repository.dart';

class LoginController extends GetxController with LoaderMixin {
  final UserRepository _repository;
  final loading = false.obs;
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: '_loginPage');

  LoginController(this._repository);
  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
  }

  final _obscureText = true.obs;

  get obscureText => _obscureText.value;

  void showHidePassword() => _obscureText.toggle();

  Future<void> login(String email, String password) async {
    try {
      loading(true);

      final user = await _repository.login(email, password);
      final sp = await SharedPreferences.getInstance();
    await sp.setString('usuario', email);
     await sp.setString('senha', password);
      await sp.setString('user', user!.toJson());
    

      loading(false);
      Get.offAndToNamed(SplashPage.ROUTE_PAGE);
    } on RestClientException catch (e) {
      print(e);
      loading(false);
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
      loading(false);
      Fluttertoast.showToast(
          msg: "Erro au autenticar usuário",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
