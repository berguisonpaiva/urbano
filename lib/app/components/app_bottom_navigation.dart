import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:urbano/app/modules/extrato/extrato_page.dart';
import 'package:urbano/app/modules/home/home_page.dart';


class AppBottomNavigation extends StatelessWidget {
  final int _curentIdex;
  const AppBottomNavigation(this._curentIdex);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _curentIdex,
        items: [
          BottomNavigationBarItem(
              label: 'Dashboard', icon: Icon(Icons.dashboard)),
          BottomNavigationBarItem(
              label: 'Extrato', icon: Icon(Icons.list_alt_outlined)),
          BottomNavigationBarItem(
              label: 'Avisos', icon: Icon(Icons.notifications)),
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
              
              break;
            default:
          }
        });
  }
}
