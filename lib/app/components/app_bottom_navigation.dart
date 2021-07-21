import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/modules/home/home_page.dart';
import 'package:urbano/app/modules/splash/splash_page.dart';

class AppBottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
 
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
              break;
            case 2:
              
              break;
            default:
          }
        });
  }
}
