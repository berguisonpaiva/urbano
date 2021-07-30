import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbano/app/helpers/loader_mixin.dart';
import 'package:urbano/app/helpers/rest_client.dart';
import 'package:urbano/app/models/encerante_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:urbano/app/models/extrato_model.dart';
import 'package:urbano/app/models/periodo_model.dart';
import 'package:urbano/app/models/user_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:urbano/app/repositories/user_repository.dart';

class ExtratoController extends GetxController with LoaderMixin, StateMixin {
  final UserRepository _repository;
  final loader = false.obs;
  final usuario =
      UserModel(grupo: '', token: '', usuario: '', permissao: '').obs;
  final periodo = <PeriodoModel>[].obs;
  final numberFormat =
      NumberFormat.currency(name: '', locale: 'pt_BR', decimalDigits: 2);
  final encerrante = <EnceranteModel>[].obs;
  final valorDiesil = 0.0.obs;
  final valorDespesas = 0.0.obs;
  final selectIdPeriodo = 0.obs;
  final selectTituloPeriodo = ('').obs;
  final periodoInicio = ('').obs;
  final periodoFim = ('').obs;
  final valorCredito = 0.0.obs;
  final valorEspecie = 0.0.obs;
  final valorTotal = 0.0.obs;
  ExtratoController(
    this._repository,
  );
  ExtratoModel? extratoModel;
  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(loader);
    final sp = await SharedPreferences.getInstance();
    var user = (UserModel.fromJson(sp.getString('user')!));
    usuario(user);

    selectIdPeriodo(usuario.value.periodo!.id);
    selectTituloPeriodo(usuario.value.periodo!.desc);
    periodoInicio(usuario.value.periodo!.inicio);
    periodoFim(usuario.value.periodo!.fim);

    periodoFindall();
    extrato();
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

  Future<void> extrato() async {
    valorCredito(0.0);
    valorDespesas(0.0);
    valorDiesil(0.0);
    valorTotal(0.0);
    change([], status: RxStatus.loading());
    try {
      final resp =
          await _repository.extrato(usuario.value, selectIdPeriodo.value);
      extratoModel = resp;

      resp?.lancamento?.forEach((element) {
        if (element.lancamentoTipo.tipo!.id == 'CREDITO') {
          valorCredito(valorCredito.value + element.valor);
        }
        if (element.lancamentoTipoNome == 'DIESEL COMUM') {
          valorDiesil(valorDiesil.value + element.valor);
        }
        if (element.lancamentoTipo.tipo!.id == 'DEBITO' &&
            element.lancamentoTipoNome != 'DIESEL COMUM' &&
            element.lancamentoTipo.id != 1351) {
          valorDespesas(valorDespesas.value + element.valor);
        }

        valorTotal(
            valorCredito.value - (valorDespesas.value + valorDiesil.value));
      });
      print(valorDiesil);
      change(resp, status: RxStatus.success());
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
    valorEspecie(0.0);
    valorTotal(0.0);
    change([], status: RxStatus.loading());
    try {
      final resp =
          await _repository.dashboard(usuario.value, selectIdPeriodo.value);

      encerrante(resp);
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

    final dataAtual = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final horaAtual = DateFormat.Hms().format(DateTime.now());
    pdf.addPage(
      pw.MultiPage(
        maxPages: 200,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        header: (pw.Context context) => pw.Container(
            child: pw.Column(children: [
          pw.Row(children: [
            pw.Text(
              'Extrato de Remisão ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${usuario.value.permissao}-${encerrante.first.nomeLinha}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ]),
          pw.Row(children: [
            pw.Text(
              'Período   ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              '${periodoInicio.value} - ${periodoFim.value}',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ]),
          pw.SizedBox(
            height: 10,
          ),

          // Resumo do periodo e saldo acumulado

          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // Resumo do periodo
                pw.Container(
                  width: Get.mediaQuery.size.width * 0.65,
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
                                'Total ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Créditos ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Débitos ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5),
                              child: extratoModel!.resultadoPerido < 0.0
                                  ? pw.Text(
                                      numberFormat.format(
                                          extratoModel?.resultadoPerido),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#FF0000')),
                                    )
                                  : pw.Text(
                                      numberFormat.format(
                                          extratoModel?.resultadoPerido),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#008000')),
                                    ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(
                                    extratoModel?.resultadoPeridoCreditos),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#0000CD')),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(
                                    extratoModel?.resultadoPeridoDebitos),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#FF0000')),
                              ),
                            )
                          ])
                        ])
                      ])),
                ),

                // saldo acumulado

                pw.Container(
                  width: Get.mediaQuery.size.width * 0.65,
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
                                'Total ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Créditos ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Débitos ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 5),
                              child: extratoModel!.saldoAcumulado < 0.0
                                  ? pw.Text(
                                      numberFormat
                                          .format(extratoModel?.saldoAcumulado),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#FF0000')),
                                    )
                                  : pw.Text(
                                      numberFormat
                                          .format(extratoModel?.saldoAcumulado),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#008000')),
                                    ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(
                                    extratoModel?.saldoAcumuladocreditos),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#0000CD')),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                numberFormat.format(
                                    extratoModel?.saldoAcumuladoDebitos),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#FF0000')),
                              ),
                            )
                          ])
                        ])
                      ])),
                ),
              ]),
          pw.SizedBox(
            height: 20,
          ),
        ])),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Wrap(children: [
               pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  'Lançamentos',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
              pw.Divider(indent: 2),
              ...List<pw.Widget>.generate(
                  extratoModel!.lancamento!.length,
                  (index) => pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(top: 8.0),
                          child: extratoModel!
                                      .lancamento![index].lancamentoTipoNome !=
                                  ''
                              ? pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                      pw.Text(
                                        '${extratoModel!.lancamento![index]
                                            .data}  ${extratoModel!.lancamento![index]
                                            .lancamentoTipoNome}',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold),
                                      ),
                                      pw.Text(
                                        numberFormat.format(extratoModel!
                                            .lancamento![index].valor),
                                        style: extratoModel!.lancamento![index]
                                                    .lancamentoTipo.tipo!.id ==
                                                'DEBITO'
                                            ? pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color:
                                                    PdfColor.fromHex('#FF0000'))
                                            : pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                color: PdfColor.fromHex(
                                                    '#0000CD')),
                                      ),
                                    ])
                               : pw.Container(),
                        ),
                             extratoModel!
                                      .lancamento![index].lancamentoTipoNome !=
                                  ''
                              ?   pw.Divider(): pw.Container(),
                      ])),
              pw.SizedBox(
                height: 30,
              ),
              pw.Container(
                width: Get.mediaQuery.size.width * 0.65,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
                child: pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.only(left: 5, bottom: 5),
                            child: pw.Text(
                              'Resumo ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  'Créditos ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  numberFormat.format(valorCredito.value),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,color:
                                                    PdfColor.fromHex('#0000CD')),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  'Diesel ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  numberFormat.format(valorDiesil.value),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,color:
                                                    PdfColor.fromHex('#FF0000')),
                                ),
                              ),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  'Outras Despesas ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  numberFormat.format(valorDespesas.value),
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,color:
                                                    PdfColor.fromHex('#FF0000')),
                                ),
                              ),
                            ],
                          ),
                          pw.Divider(),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child: pw.Text(
                                  'Total Saldo ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.only(left: 5),
                                child:extratoModel!.resultadoPerido < 0.0
                                  ? pw.Text(
                                      numberFormat.format(
                                          extratoModel?.resultadoPerido),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#FF0000')),
                                    )
                                  : pw.Text(
                                      numberFormat.format(
                                          extratoModel?.resultadoPerido),
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColor.fromHex('#008000')),
                                    ),
                              ),
                            ],
                          ),
                        ])),
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
