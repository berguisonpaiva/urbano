import 'package:get/get.dart';
import 'package:urbano/app/modules/splash/splash_controller.dart';
import 'package:urbano/app/repositories/user_repository.dart';


class SplashBinding implements Bindings {
  @override
  void dependencies() {
     Get.put(UserRepository(Get.find(), ));
    Get.put(SplashController(Get.find()));
  }
}
