import 'package:combos/combos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:urbano/app/components/app_bottom_navigation.dart';
import 'package:urbano/app/models/encerante_model.dart';

import 'package:urbano/app/models/periodo_model.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  static const String ROUTE_PAGE = '/home';
  static const int NAVIGATION_BAR_INDEX = 0;
  final numberFormat =
      NumberFormat.currency(name: '', locale: 'pt_BR', decimalDigits: 2);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        bottomNavigationBar: AppBottomNavigation(NAVIGATION_BAR_INDEX),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           Obx(
      () =>   Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListCombo<PeriodoModel>(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(controller.selectTituloPeriodo.value),
                    ),
                    getList: () => controller.periodo.reversed.toList(),
                    itemBuilder: (context, parameters, item) =>
                        ListTile(title: Text(item.desc)),
                    onItemTapped: (item) {
                      controller.selectIdPeriodo(item.id);
                      controller.selectTituloPeriodo(item.desc);
                      controller.dashbord();
                    },
                  ),
                ),
              ),),
            controller.obx((state) => Expanded(flex: 3, child: _encerante(state)))  ,
              controller.obx((state) => Expanded( child:  _resumo(state)))  ,
              
            ],
          ),
        ),
      
    );
  }

  Visibility _encerante(List<EnceranteModel> state) {
    return Visibility(
      visible: state.length > 0,
      replacement: Container(child: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset(
                        'assets/images/sem-dados.png',
                      
                      ),
          Text('Periodo sem dados',style: TextStyle(fontSize: 20),),
        ],
      )),),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: PageView.builder(
          itemCount: state.length,
          itemBuilder: (_, index) {
            var iten = state[index];

            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 260,
                      child: Card(
                        elevation: 4,
                        color: Colors.amber[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('DATA'),
                                    Text(iten.dataEncerrante!)
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('CARRO'),
                                    Text(iten.numeroLinha!)
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                              ),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VIAGENS'),
                                    Text(iten.qtdViagens.toString())
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 5),
                              child: Text('*********************************'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17.0, right: 18),
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ESTUDANTE'),
                                    Text(
                                        numberFormat.format(iten.valorEstudant))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VT'),
                                    Text(numberFormat.format(iten.valorVt))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('EST_CDE'),
                                    Text(numberFormat.format(iten.valorEstCde))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VT.AVUL'),
                                    Text(numberFormat.format(iten.valorVtAvul))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('BUM_VTA'),
                                    Text(numberFormat.format(iten.valorBumVta))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('BUM_VTM'),
                                    Text(numberFormat.format(iten.valorBumVtm))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('BUM_ESM'),
                                    Text(numberFormat.format(iten.valorBumEsm))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('PAGORD'),
                                    Text(numberFormat.format(iten.valorPagord))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('AENEM'),
                                    Text(numberFormat.format(iten.valorAenem))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('LBPREPG'),
                                    Text(numberFormat.format(iten.valorLbprepg))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 5),
                              child: Text('*********************************'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17.0, right: 18),
                              child: Divider(
                                thickness: 2,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VALOR TOTAL VTE'),
                                    Text(numberFormat.format(iten.valorVte))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('PAGANTES'),
                                    Text(iten.qtdPagantes.toString())
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TARIFA'),
                                    Text(numberFormat.format(iten.tarifa))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17.0, right: 18),
                              child: Divider(
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('VAL.JORNADA'),
                                    Text(numberFormat.format(iten.valorJornada))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Visibility _resumo(state) {
    return Visibility(
      visible: state.length > 0,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
         
          width: 260,
          child: Card(
             color: Colors.amber[300],
            elevation: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:5,bottom: 0),
                  child: Text('RESUMO DO PERIODO',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                ),
                
                Divider(color: Colors.white,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5),
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VTE',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(numberFormat.format(controller.valorVTE.value),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5),
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ESPECIE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(numberFormat.format(controller.valorEspecie.value),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5),
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(numberFormat.format(controller.valorTotal.value),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
