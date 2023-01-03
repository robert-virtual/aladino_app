import 'package:aladino/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InventarioForm extends GetView<HomeController> {
  InventarioForm({Key? key}) : super(key: key);
  final paca = TextEditingController(text: "S/P");
  final tamano = TextEditingController();
  final corte = TextEditingController(text: "CNA");
  final libras = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 20),
          const Text(
            "Agregar Inventario",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: paca,
            decoration: const InputDecoration(
              label: Text(
                "Paca",
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Clase",
          ),
          Obx(
            () => DropdownButton<String>(
              value: controller.clase.value,
              items: controller.clases.value
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (text) {
                controller.clase.value = text ?? controller.clases.value[0];
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Variedad",
          ),
          Obx(
            () => DropdownButton<String>(
              value: controller.variedad.value,
              items: controller.variedades.value
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (text) {
                controller.variedad.value =
                    text ?? controller.variedades.value[0];
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Detalle",
          ),
          Obx(
            () => DropdownButton<String>(
              value: controller.detalle.value,
              items: controller.detalles.value
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (text) {
                controller.detalle.value = text ?? controller.detalles.value[0];
              },
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: tamano,
            decoration: const InputDecoration(
              label: Text(
                "TAMAÑO",
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: corte,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text(
                "CORTE",
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: libras,
            decoration: const InputDecoration(
              label: Text(
                "LIBRAS",
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Fecha: ${f.format(DateTime.now())}"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () async {
          if (checkData()) {
            Get.dialog(
              AlertDialog(
                title: const Text("Falta informacion"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [Text("Debes llenar todos los campos")],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
            return;
          }
          final res = await Get.showOverlay(
            loadingWidget: const Center(child: CircularProgressIndicator()),
            asyncFunction: () async {
              //guardar cuenta por cobrar
              String res = await controller.sendSheet(
                range: "inventario!A:G",
                data: [
                  paca.text,
                  controller.clase.value,
                  controller.variedad.value,
                  controller.detalle.value,
                  tamano.text,
                  corte.text,
                  libras.text
                ],
              );
              return res;
            },
          );
          Get.back();
          Get.snackbar("Guardar Datos", res);
        },
      ),
    );
  }

  bool checkData() {
    return tamano.text.isEmpty || libras.text.isEmpty;
  }
}
