import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:validatorless/validatorless.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
    static const String ROUTE_PAGE = '/login';
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.mediaQuery.size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_urbano.png',color: Get.theme.primaryColor,
                        height: 150,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: controller.emailEditingController,
                            
                              validator: 
                                Validatorless.required('O campo é obrigatório'),
                              
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20),
                                  labelText: 'Usuário',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      gapPadding: 0)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () => TextFormField(
                                controller:
                                    controller.passwordEditingController,
                                obscureText: controller.obscureText,
                                validator:Validatorless.required('O campo é obrigatório'),
                                decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: IconButton(
                                          icon: controller.obscureText == true
                                              ? Icon(LineIcons.eye)
                                              : Icon(LineIcons.eyeSlash),
                                          onPressed: () {
                                            controller.showHidePassword();
                                          }),
                                    ),
                                    labelText: 'Senha',
                                    contentPadding: EdgeInsets.only(left: 20),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        gapPadding: 0)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.login(
                                    controller.emailEditingController.text,
                                    controller.passwordEditingController.text);
                              }
                            },
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )))),
                      ),
 SizedBox(
                        height: 15,
                      ),
                      
                    ],
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
