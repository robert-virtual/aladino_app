
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:aladino/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aladino Cigars"),
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
          return RefreshIndicator(
            onRefresh: () =>
                Future.sync(() => controller.almacenCtrl.refresh()),
            child: PagedListView<int, List>(
              pagingController: controller.almacenCtrl,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, idx) {
                  return Card(child: Column(children: [
                  Text(item[0])
                  ]),) ;
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Spreadsheets"),
        onPressed: () {
          Get.toNamed("/drivefiles");
        },
        icon: const Icon(Icons.list),
      ),
    );
  }
}
