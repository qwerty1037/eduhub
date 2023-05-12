import 'package:flutter/material.dart';

class CircularConfirmButton extends StatelessWidget {
  final double radius;
  final VoidCallback onPressedFunction;
  final String text;
  const CircularConfirmButton(
      {super.key,
      required this.onPressedFunction,
      this.radius = 5.0,
      this.text = "Confirm"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedFunction,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 200),
        shape: const CircleBorder(),
      ),
      child: Text(text),
    );
  }
}
