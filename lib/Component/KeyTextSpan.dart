import 'package:flutter/material.dart';

class KeyText extends StatelessWidget {
  final String text;
  const KeyText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
