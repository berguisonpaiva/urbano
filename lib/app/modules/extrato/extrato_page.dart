import 'package:combos/combos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbano/app/components/app_bottom_navigation.dart';
import 'package:urbano/app/models/extrato_model.dart';
import 'package:urbano/app/models/periodo_model.dart';


import 'extrato_controller.dart';

class ExtratoPage extends GetView<ExtratoController> {
  static const String ROUTE_PAGE = '/extrato';
  static const int NAVIGATION_BAR_INDEX = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extrato'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 1,
                child: Text('Pdf'),
              ),
            ],
            onSelected: (value) => controller.shared(),
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(NAVIGATION_BAR_INDEX),
      body: Container(
        child:LayoutBuilder(
            builder: (_, constrains) { 
                return  Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
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
                               controller.periodoFim(item.fim);
                                controller.periodoInicio(item.inicio);
                             
      
                              controller.extrato();
                               controller.dashbord();
                            },
                          ),
                        ),
                      ),
                    ),
     
                    controller.obx((state) => _extrato(state)),
               
                  ],
                );
            },
          )
      ),
    );
  }

  Visibility _extrato(ExtratoModel state) {
    return Visibility(
        visible: true,
   
          child: Expanded(
            child: ListView(
              
            
              children: [
                Container( height: 90,child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(child: Padding(
                  padding: const EdgeInsets.only(top: 8.0,left: 20.0,bottom: 8.0,right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text('SALDO ACUMULADO'),
                    state.saldoAcumulado >= 0.0 ?  Text(controller.numberFormat
                                  .format(state.saldoAcumulado),
                              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16)):Text(controller.numberFormat
                                  .format(state.saldoAcumulado),
                              style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16)),
                  ],),
                ),),
              ),),
              Container(
                height: 95,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Resultado do Periodo'),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 30,top: 10),
                        child: Table(
                       
                          children: [
                            TableRow(
                              children: [
                               
                                  Text('CRÉDITOS',style: TextStyle(fontWeight: FontWeight.bold)),
                                   Text('DEBITOS',style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('TOTAL',style: TextStyle(fontWeight: FontWeight.bold)),
                              ]
                            ),
                            TableRow(
                              children: [
                               
                           Text(controller.numberFormat
                              .format(state.resultadoPeridoCreditos),
                          style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 16)),
                           Text(controller.numberFormat
                              .format(state.resultadoPeridoDebitos),
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16)),
                         state.resultadoPerido >= 0.0 ?  Text(controller.numberFormat
                              .format(state.resultadoPerido),
                          style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16)):Text(controller.numberFormat
                              .format(state.resultadoPerido),
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 16)),
                                 
                              ]
                            )
                          ],

                        ),
                      )
                  
                    ],),
                  ),
                ),
              ),
               
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('CRÉDITOS',style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                  controller.numberFormat
                                      .format(controller.valorCredito.value),
                                  style: TextStyle(color: Colors.blue))
                            ],
                          ),
                          children: [
                            for (var test in controller.encerrante)
                              
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(test.dataEncerrante!),
                                      test.valorVte != 0.0
                                          ? Text(
                                              controller.numberFormat.format(test.valorVte),
                                              style: TextStyle(color: Colors.blue),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                          ],
                        ),
                        ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('DIESIL',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  controller.numberFormat
                                      .format(controller.valorDiesil.value),
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                          children: [
                            for (var test in state.lancamento!)
                              if (test.lancamentoTipoNome == 'DIESEL COMUM')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(test.data!),
                                      Text(
                                        controller.numberFormat.format(test.valor),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                )
                          ],
                        ),
                        ExpansionTile(
                          title: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('OUTRAS DESPESAS',style: TextStyle(fontWeight: FontWeight.bold)),
                               Text(
                                  controller.numberFormat
                                      .format(controller.valorDespesas.value),
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                          children: [
                            for (var test in state.lancamento!)
                              if (test.lancamentoTipo.tipo!.id == 'DEBITO' &&
                                  test.lancamentoTipoNome != 'DIESEL COMUM' && test.lancamentoTipo.id !=1351)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(test.lancamentoTipoNome),
                                  
                                     Text(
                                          controller.numberFormat.format(test.valor),
                                          style: TextStyle(color: Colors.red)),
                                  ],
                                  ),
                                )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
