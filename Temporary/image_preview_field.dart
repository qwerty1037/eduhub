
/*
Widget imagePreviewField() {
    return Obx(() {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '캡처된 이미지 ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: controller.imagePreviewButtonText(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                controller.whenImagePreviewButtonTapped();
              },
            ),
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: controller.isImagePreviewButtonTapped.value,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: constraints.maxWidth / 2.2,
                      height: constraints.maxWidth / 1.6,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                      ),
                      child: Image.memory(controller.capturedImageProblem),
                    ),
                    const Expanded(child: SizedBox()),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: constraints.maxWidth / 2.2,
                      height: constraints.maxWidth / 1.6,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                      ),
                      child: Image.memory(controller.capturedImageAnswer),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    });
  }
*/