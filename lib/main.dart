import 'package:aladino/pages/inventario_form.dart';
import 'package:aladino/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:aladino/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  timeago.setLocaleMessages("es", timeago.EsMessages());
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/menu",
      getPages: [
        GetPage(
          name: "/menu",
          page: () => const MenuPage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: "/inventario_form",
          page: () => InventarioForm(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: "/home",
          page: () => const HomePage(),
          binding: HomeBinding(),
        ),
      ],
    ),
  );
}
