import 'package:get/get.dart';
import 'package:urbano/app/modules/home/home_controller.dart';
import 'package:urbano/app/repositories/user_repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository(Get.find()));
    Get.put(HomeController(Get.find()));
  }
}
