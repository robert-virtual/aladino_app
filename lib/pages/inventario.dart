import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';

class InventarioPage extends GetView<HomeController> {
  const InventarioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventario"),
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
          return FutureBuilder(
            future: controller.getSheet(range: "!A:Z", removeFirst: true),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text("Error: ${snap.error}"));
              }
              final data = snap.data ?? List.empty();
              if (data.isEmpty) {
                return const Center(child: Text("No hay datos que mostar"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: data.length,
                itemBuilder: (context, idx) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text("Agregar consumo"),
                          content: Obx(
                            () => TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) => controller
                                  .librasConsumo.value = int.parse(value),
                              decoration: InputDecoration(
                                label: const Text("Libras consumidas"),
                                errorText: controller.librasConsumo.value >
                                        int.parse(data[idx][6])
                                    ? "Solo se cuenta con ${data[idx][6]} libras de este item"
                                    : null,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                controller.librasConsumo.value = 0;
                                Get.back();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Get.showOverlay(asyncFunction: () async {
                                  if (controller.librasConsumo.value >
                                      int.parse(
                                        data[idx][6],
                                      )) {
                                    return;
                                  }
                                  var consumo = [...data[idx]];
                                  consumo[6] = controller.librasConsumo.value;
                                  await controller.sendSheet(
                                      range: "consumo!A:G", data: consumo);
                                  final index = data.length - idx + 1;
                                  consumo[6] = int.parse(data[idx][6]) -
                                      controller.librasConsumo.value;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "${data[idx][6]} - ${controller.librasConsumo.value}: ${int.parse(data[idx][6]) - controller.librasConsumo.value}")));

                                  await controller.updateSheet(
                                      range: "inventario!A$index:G$index",
                                      data: consumo);
                                });
                                Get.back();
                              },
                              child: const Text("Guardar"),
                            )
                          ],
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Paca: ",
                              ),
                              TextSpan(
                                text: data[idx][0],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Clase: ",
                              ),
                              TextSpan(
                                text: data[idx][1],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Variedad: ",
                              ),
                              TextSpan(
                                text: data[idx][2],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Detalle: ",
                              ),
                              TextSpan(
                                text: data[idx][3],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "TAMAÑO: ",
                              ),
                              TextSpan(
                                text: data[idx][4],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Corte: ",
                              ),
                              TextSpan(
                                text: data[idx][5],
                              ),
                            ])),
                            Text.rich(TextSpan(children: [
                              const TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                text: "Libras: ",
                              ),
                              TextSpan(
                                text: data[idx][6],
                              ),
                            ])),
                          ],
                        ),
                      ),
                    ),
                  );
                  /* return const Text("imagen"); */
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.toNamed("/inventario_form");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
