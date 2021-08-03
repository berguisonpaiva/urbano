import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:urbano/app/components/app_bottom_navigation.dart';
import './menu_controller.dart';

class MenuPage extends GetView<MenuController> {
  static const ROUTE_PAGE = '/menu';
   static const int NAVIGATION_BAR_INDEX = 2;
@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Menu'),),
        body: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
           
              
           InkWell(
             onTap: ()=>controller.sair(),
             child: Container(
           
                  width: Get.mediaQuery.size.width * 0.6,
                  height: 80,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon( Icons.exit_to_app,size: 30,),
                    Text('Sair')
                  ],),)
                ),
           ),
     
          ],
        ),
        bottomNavigationBar: AppBottomNavigation(NAVIGATION_BAR_INDEX),
    );
}
}