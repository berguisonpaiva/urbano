import 'package:get/get.dart';
import 'package:urbano/app/repositories/user_repository.dart';

import 'extrato_controller.dart';

class ExtratoBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserRepository(Get.find()));
    Get.put(ExtratoController(Get.find()));
  }
}