import 'package:get/get.dart';
import 'package:urbano/app/modules/logi/login_controller.dart';
import 'package:urbano/app/repositories/user_repository.dart';


class LoginBinding implements Bindings {
  @override
  void dependencies() {
    
    Get.put(UserRepository(Get.find()));
    Get.put(LoginController(Get.find()));
  }
}
