import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/config/application_binding.dart';
import 'app/config/ui_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: UiConfig.appTheme,
      getPages: UiConfig.routes,
      initialBinding: ApplicationBinding(),
    );
  }
}
