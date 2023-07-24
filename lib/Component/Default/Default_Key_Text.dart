import 'package:flutter/material.dart';

/// Format of title of TextField
///
/// 텍스트필드의 제목 양식
class DefaultKeyText extends StatelessWidget {
  final String text;
  const DefaultKeyText({
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
