
/*
Widget difficultyInputField() {
  return Column(
    children: [
      Stack(
        children: [
          const DefaultTitle(text: "난이도"),
          Align(
            alignment: Alignment.center,
            child: Obx(
              () => Text(
                "[${controller.difficultySliderValue.value.round()}]",
                style: const TextStyle(
                  fontSize: 35,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Obx(() {
        return Slider(
          max: 5,
          min: 0,
          divisions: 5,
          value: controller.difficultySliderValue.value,
          label: controller.difficultySliderValue.value.round().toString(),
          onChanged: (double value) {
            controller.difficultySliderValue.value = value;
          },
        );
      }),
    ],
  );
}
*/
