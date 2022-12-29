import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';
import 'package:google_sign_in/widgets.dart';

class CuentaPage extends GetView<HomeController> {
  const CuentaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuenta"),
      ),
      body: GetBuilder<HomeController>(
        builder: (_) {
          if (controller.account == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.signIn();
                },
                child: const Text("Iniciar Session"),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.signOut,
                  child: const Text("Cerrar Session"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
