import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/helpers/loader_mixin.dart';
import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';
import 'package:urbano/app/models/periodo_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbano/app/models/user_model.dart';

import 'package:urbano/app/repositories/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class HomeController extends GetxController with StateMixin, LoaderMixin {
  final UserRepository _repository;
  final loader = false.obs;
  final usuario =
      UserModel(grupo: '', token: '', usuario: '', permissao: '').obs;
  final numberFormat =
      NumberFormat.currency(name: '', locale: 'pt_BR', decimalDigits: 2);
  final periodo = <PeriodoModel>[].obs;
  final encerrante = <EnceranteModel>[].obs;
  final selectIdPeriodo = 0.obs;
  final selectTituloPeriodo = ('').obs;
  final valorVTE = 0.0.obs;
  final periodoInicio = ('').obs;
  final periodoFim = ('').obs;
  final valorEspecie = 0.0.obs;
  final valorTotal = 0.0.obs;
  List<EnceranteModel>? enceranteModel;
  HomeController(
    this._repository,
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(loader);
    final sp = await SharedPreferences.getInstance();
    var user = (UserModel.fromJson(sp.getString('user')!));
    usuario(user);
    periodoInicio(usuario.value.periodo!.inicio);
    periodoFim(usuario.value.periodo!.fim);
    selectIdPeriodo(usuario.value.periodo!.id);
    selectTituloPeriodo(usuario.value.periodo!.desc);
    print(selectIdPeriodo);
    periodoFindall();
    dashbord();
  }

  Future<void> periodoFindall() async {
    try {
      final resp = await _repository.periodo(usuario.value);

      periodo(resp);
    } on RestClientException catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: "Erro!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> dashbord() async {
    valorVTE(0.0);
    valorEspecie(0.0);
    valorTotal(0.0);
    change([], status: RxStatus.loading());
    try {
      final resp =
          await _repository.dashboard(usuario.value, selectIdPeriodo.value);
      enceranteModel = resp;
      enceranteModel
          ?.sort((a, b) => a.dataEncerrante!.compareTo(b.dataEncerrante!));
      encerrante(resp);
      encerrante.forEach((element) {
        valorVTE(valorVTE.value + element.valorVte!);
        valorEspecie(valorEspecie.value + element.valorEspecie!);
      });
      valorTotal(valorVTE.value + valorEspecie.value);
      change(encerrante, status: RxStatus.success());
    } on RestClientException catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
          msg: "Erro!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> shared() async {
    final pdf = pw.Document();
    final imagePng = (await rootBundle.load('assets/images/cabeca.png'))
        .buffer
        .asUint8List();
    final dataAtual = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final horaAtual = DateFormat.Hms().format(DateTime.now());
    pdf.addPage(
      pw.MultiPage(
        maxPages: 200,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        header: (pw.Context context) => pw.Container(
            child: pw.Column(children: [
          pw.Image(pw.MemoryImage(imagePng)),
          pw.SizedBox(height: 15),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 8),
            child: pw.Row(children: [
              pw.Text(
                'Encerantes  ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${usuario.value.permissao} - ${encerrante.first.nomeLinha}',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ]),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(left: 8),
            child: pw.Row(children: [
              pw.Text(
                'Periodo  ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
               '${periodoInicio.value} - ${periodoFim.value}',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ]),
          ),
          
          pw.SizedBox(
            height: 10,
          ),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // Resumo do periodo
                pw.Container(
                  width: Get.mediaQuery.size.width * 0.80,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColor.fromHex('#000000'),
                    ),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Padding(
                      padding: pw.EdgeInsets.all(8.0),
                      child: pw.Column(children: [
                        pw.Text(
                          'Resumo do Periodo ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Table(children: [
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5),
                              child: pw.Text(
                                'VTE ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'ESPECIE ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'TOTAL ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5),
                              child: pw.Text(
                                numberFormat.format(valorVTE.value),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#0000CD')),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(valorEspecie.value),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#0000CD')),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(valorTotal.value),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#0000CD')),
                              ),
                            )
                          ])
                        ])
                      ])),
                ),

                // saldo acumulado
              ]),
          pw.SizedBox(
            height: 40,
          ),
        ])),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Wrap(children: [
              ...List<pw.Widget>.generate(
                enceranteModel!.length,
                (index) => pw.Wrap(children: [
                  pw.Column(children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.all(2.0),
                        child: pw.Container(
                            color: PdfColor.fromHex('#F0E68C'),
                            width: 180,
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, top: 10, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('DATA'),
                                          pw.Text(enceranteModel![index]
                                              .dataEncerrante!)
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('CARRO'),
                                          pw.Text(enceranteModel![index]
                                              .numeroLinha!)
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('VIAGENS'),
                                          pw.Text(enceranteModel![index]
                                              .qtdViagens
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10, top: 5),
                                    child: pw.Text(
                                        '*********************************'),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Divider(),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('ESTUDANTE'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorEstudant))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('VT'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index].valorVt))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('EST_CDE'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorEstCde))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('VT.AVUL'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorVtAvul))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('BUM_VTA'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorBumVta))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('BUM_VTM'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorBumVtm))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('BUM_ESM'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorBumEsm))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('PAGORD'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorPagord))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('AENEM'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorAenem))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('LBPREPG'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorLbprepg))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10, top: 5),
                                    child: pw.Text(
                                        '*********************************'),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Divider(
                                      thickness: 2,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('VALOR TOTAL VTE'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index].valorVte))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10, top: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('PAGANTES'),
                                          pw.Text(enceranteModel![index]
                                              .qtdPagantes
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('TARIFA'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index].tarifa))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Divider(
                                      thickness: 1,
                                    ),
                                  ),
                                  pw.Padding(
                                    padding: pw.EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: pw.Container(
                                      width: 200,
                                      child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('VAL.JORNADA'),
                                          pw.Text(numberFormat.format(
                                              enceranteModel![index]
                                                  .valorJornada))
                                        ],
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(height: 10)
                                ])))
                  ])
                ]),
              ),
            ])
          ];
        },
        footer: (pw.Context context) => pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: pw.Text('${dataAtual.toString()}--${horaAtual.toString()}')),
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/relatorio-carro.pdf';
    final File file = File(path);

    file.writeAsBytesSync(await pdf.save());
    showAlentl(file, path);
  }

  Future<void> showAlentl(File file, String path) async {
    PDFDocument doc = await PDFDocument.fromFile(file);
    try {
      await showBarModalBottomSheet(
          context: Get.context!,
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Relatório'),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                      onPressed: () {
                        ShareExtend.share(path, "file",
                            sharePanelTitle: "Enviar PDF",
                            subject: "Relatorio de Manutenção -pdf");
                      }),
                ],
              ),
              body: PDFViewer(document: doc),
            );
          });
    } catch (e) {
      print(e);
    }
  }
}
