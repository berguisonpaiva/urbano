import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import 'package:urbano/app/modules/extrato/extrato_page.dart';
import 'package:urbano/app/modules/home/home_page.dart';
import 'package:urbano/app/modules/menu/menu_page.dart';

class AppBottomNavigation extends StatelessWidget {
  final int _curentIdex;
  const AppBottomNavigation(this._curentIdex);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _curentIdex,
        items: [
          BottomNavigationBarItem(
              label: 'Encerrante', icon: Icon(Icons.business_sharp)),
          BottomNavigationBarItem(
              label: 'Extrato', icon: Icon(Icons.list_alt)),
          BottomNavigationBarItem(label: 'Menu', icon: Icon(Icons.menu)),
        ],
        onTap: (index) async {
          switch (index) {
            case 0:
              Get.offAllNamed(HomePage.ROUTE_PAGE);
              break;
            case 1:
              Get.offAllNamed(ExtratoPage.ROUTE_PAGE);
              break;
            case 2:
               Get.offAllNamed(MenuPage.ROUTE_PAGE);
              break;
            default:
          }
        });
  }
}
