import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';
import 'package:intl/intl.dart';

class InventarioPage extends GetView<HomeController> {
  InventarioPage({super.key});
  final formatDate = DateFormat("yyyy-MM-dd");
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.searching.value
            ? TextField(
                focusNode: focusNode,
                onSubmitted: (value) {},
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Paca...",
                ),
              )
            : const Text("Inventario")),
        actions: [
          IconButton(
            onPressed: () {
              controller.searching.value = !controller.searching.value;
              focusNode.requestFocus();
            },
            icon: Obx(
              () =>
                  Icon(controller.searching.value ? Icons.close : Icons.search),
            ),
          )
        ],
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
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                      title: Text(
                        " ${data.length} items",
                        style: const TextStyle(color: Colors.black),
                      ),
                      actions: [
                        Wrap(
                          spacing: 2.0,
                          children: [
                            ChoiceChip(
                              selected: false,
                              label: Row(children: const [
                                Text("Clase"),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                )
                              ]),
                              onSelected: (value) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Obx(
                                    () => Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Clase",
                                                  style:
                                                      TextStyle(fontSize: 25.0),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text("Ok"),
                                              )
                                            ]),
                                        ...List.generate(
                                          controller.clases.length,
                                          (i) => RadioListTile<String>(
                                            title: Text(controller.clases[i]),
                                            value: controller.clases[i],
                                            groupValue:
                                                controller.filtroClase.value,
                                            onChanged: (value) {
                                              controller.filtroClase.value =
                                                  value ?? controller.clases[i];
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ChoiceChip(
                              selected: false,
                              label: Row(
                                children: const [
                                  Text("Variedad"),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              onSelected: (value) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Obx(
                                    () => Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Variedad",
                                                  style:
                                                      TextStyle(fontSize: 25.0),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text("Ok"),
                                              )
                                            ]),
                                        ...List.generate(
                                          controller.variedades.length,
                                          (i) => RadioListTile<String>(
                                            title:
                                                Text(controller.variedades[i]),
                                            value: controller.variedades[i],
                                            groupValue:
                                                controller.filtroVariedad.value,
                                            onChanged: (value) {
                                              controller.filtroVariedad.value =
                                                  value ??
                                                      controller.variedades[i];
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            ChoiceChip(
                              selected: false,
                              label: Row(
                                children: const [
                                  Text("Detalle"),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              onSelected: (value) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Obx(
                                    () => ListView(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Detalle",
                                                  style:
                                                      TextStyle(fontSize: 25.0),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text("Ok"),
                                              )
                                            ]),
                                        ...List.generate(
                                          controller.detalles.length,
                                          (i) => RadioListTile<String>(
                                            title: Text(controller.detalles[i]),
                                            value: controller.detalles[i],
                                            groupValue:
                                                controller.filtroDetalle.value,
                                            onChanged: (value) {
                                              controller.filtroDetalle.value =
                                                  value ??
                                                      controller.detalles[i];
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                      primary: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, idx) {
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
                                  await Get.showOverlay(
                                    asyncFunction: () async {
                                      if (controller.librasConsumo.value >
                                          int.parse(
                                            data[idx][6],
                                          )) {
                                        return;
                                      }
                                      var consumo = [...data[idx]];
                                      consumo[6] =
                                          controller.librasConsumo.value;
                                      await controller.sendSheet(
                                          range: "consumo!A:H", data: consumo);
                                      final index = data.length - idx + 1;
                                      consumo[6] = int.parse(data[idx][6]) -
                                          controller.librasConsumo.value;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "${data[idx][6]} - ${controller.librasConsumo.value}: ${int.parse(data[idx][6]) - controller.librasConsumo.value}")));

                                      await controller.updateSheet(
                                          range: "inventario!A$index:H$index",
                                          data: consumo);
                                    },
                                    loadingWidget: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
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
                              Text(formatDate
                                  .format(DateTime.parse(data[idx][7])))
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
                ],
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
