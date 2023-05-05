import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleController extends GetxController {
  int counter = 0;

  void increase() {
    counter++;
    update();
  }
}

class ReactiveController extends GetxController {
  RxInt counter = 0.obs;

  void increase() {
    counter++;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SimpleController()); //Controller 등록
    Get.put(ReactiveController());
    return Scaffold(
      appBar: AppBar(title: const Text("단순 상태 관리")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //단순 상태 관리
            GetBuilder<SimpleController>(
              builder: (controller) {
                return ElevatedButton(
                  onPressed: () {
                    controller.increase();
                  },
                  child: Text('[단순]현재 숫자: ${controller.counter}'),
                );
              },
            ),
            //반응형 상태 관리 1
            GetX<ReactiveController>(
              builder: (controller) {
                return ElevatedButton(
                  onPressed: () {
                    controller.increase();
                  },
                  child: Text(
                    '반응형 1 / 현재 숫자: ${controller.counter.value}',
                  ), //Value로 접근
                );
              },
            ),
            //반응형 상태 관리 2
            Obx(
              () {
                return ElevatedButton(
                  onPressed: () {
                    Get.find<ReactiveController>().increase();
                  },
                  child: Text(
                    '반응형 2 / 현재 숫자: ${Get.find<ReactiveController>().counter.value}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
