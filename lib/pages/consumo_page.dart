import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aladino/controllers/home_controller.dart';

class ConsumoPage extends GetView<HomeController> {
  const ConsumoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consumo"),
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
            future: controller.getSheet(range: "consumo!A:Z", removeFirst: true),
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
                  return Card(
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
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  text: "Clase: ",
                                ),
                                TextSpan(
                                  text: data[idx][1],
                                ),
                              ],
                            ),
                          ),
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
                  );
                  /* return const Text("imagen"); */
                },
              );
            },
          );
        },
      ),
      
    );
  }
}
