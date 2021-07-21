import 'package:get/get.dart';
import 'package:urbano/app/helpers/rest_client.dart';


class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestClient(), fenix: true);
  }
}
