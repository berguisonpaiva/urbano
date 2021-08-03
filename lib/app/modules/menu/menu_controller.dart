import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';

class MenuController extends GetxController {
    Future<void> sair() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    Get.offAllNamed(SplashPage.ROUTE_PAGE);
  }
}