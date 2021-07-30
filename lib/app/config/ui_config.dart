import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbano/app/modules/extrato/extrato_binding.dart';
import 'package:urbano/app/modules/extrato/extrato_page.dart';
import 'package:urbano/app/modules/home/home_binding.dart';
import 'package:urbano/app/modules/home/home_page.dart';
import 'package:urbano/app/modules/logi/login_binding.dart';
import 'package:urbano/app/modules/logi/login_page.dart';
import 'package:urbano/app/modules/splash/splash_binding.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';

class UiConfig {
  UiConfig._();

  static final appTheme = ThemeData(
     primaryColor: Color(0xFF074607),
      primaryColorDark: Color(0xFF074607),
      primaryColorLight: Color(0xFFFF5030),
      primarySwatch: Colors.green,
      accentColor: Color(0xFF484848));
  

  static final routes = <GetPage>[
    GetPage(
      name: SplashPage.ROUTE_PAGE,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: HomePage.ROUTE_PAGE,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: LoginPage.ROUTE_PAGE,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: ExtratoPage.ROUTE_PAGE,
      page: () => ExtratoPage(),
      binding: ExtratoBinding(),
    ),
  ];
}
