import 'package:aladino/pages/cuenta_page.dart';
import 'package:aladino/pages/inventario.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';

class MenuPage extends GetView<HomeController> {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (_) => controller.account != null
            ? IndexedStack(
                index: controller.currentPage,
                children: const [
                  InventarioPage(),
                  CuentaPage(),
                ],
              )
            : Center(
                child: ElevatedButton(
                  onPressed: controller.signIn,
                  child: const Text("Iniciar Session"),
                ),
              ),
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        builder: (_) => BottomNavigationBar(
          currentIndex: controller.currentPage,
          onTap: controller.setCurrentPage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: "Inventario",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: "Cuenta",
            ),
          ],
        ),
      ),
    );
  }
}
