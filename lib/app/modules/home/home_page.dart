import 'package:combos/combos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbano/app/components/app_bottom_navigation.dart';
import 'package:urbano/app/models/periodo_model.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  static const String ROUTE_PAGE = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 1,
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) => controller.sair(),
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListCombo<PeriodoModel>(
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Combo child'),
                ),
                getList: () => controller.periodo.reversed.toList(),
                itemBuilder: (context, parameters, item) =>
                    ListTile(title: Text(item.desc!)),
                onItemTapped: (item) {
                  controller.dashbord(item.id!);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
