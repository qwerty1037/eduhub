import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Getx/CounterController.dart';

void main() {
  runApp(const GetMaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text("Clicks: ${controller.count}"))),
        body: Center(
            child: ElevatedButton(
                child: const Text("Go to Other"),
                onPressed: () => Get.to(const Other()))),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ));
  }
}

class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    CounterController controller = Get.find();
    return Scaffold(
      body: Center(
        child: Text("${controller.count}"),
      ),
    );
  }
}
