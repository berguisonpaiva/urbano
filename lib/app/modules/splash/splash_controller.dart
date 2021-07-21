import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:urbano/app/models/user_logged.dart';
import 'package:urbano/app/modules/home/home_page.dart';
import 'package:urbano/app/modules/logi/login_page.dart';
import 'package:urbano/app/repositories/user_repository.dart';

class SplashController extends GetxController {
  final UserRepository _repository;
  var _logged = UserLogged.empty.obs;
  SplashController(
    this._repository,
  );

  UserLogged get logged => _logged.value;

  @override
  void onInit() {
    super.onInit();
    ever<UserLogged>(_logged, _checkIsLogged);
    checkLogin();
  }

  Future<void> checkLogin() async {
    final sp = await SharedPreferences.getInstance();

    if (sp.containsKey('usuario') & sp.containsKey('senha')) {
      try {
        final user = await _repository.login(
            sp.getString('usuario')!, sp.getString('senha')!);

        await sp.setString('user', user!.toJson());
        _logged(UserLogged.authenticate);
      } catch (e) {
        print(e);
        sp.clear();
        _logged(UserLogged.unauthenticate);
      }
    } else {
      _logged(UserLogged.unauthenticate);
    }
  }

  void _checkIsLogged(UserLogged userLogged) {
    switch (userLogged) {
      case UserLogged.authenticate:
        Get.offAllNamed(HomePage.ROUTE_PAGE);
        break;
      case UserLogged.unauthenticate:
        Get.offAllNamed(LoginPage.ROUTE_PAGE);
        break;
      case UserLogged.empty:
        break;
      default:
    }
  }
}
