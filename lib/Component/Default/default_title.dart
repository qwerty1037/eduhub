import 'package:flutter/material.dart';

// TODO 다크모드에서 글자색 바뀌는지 확인
class DefaultTitle extends StatelessWidget {
  final String text;
  const DefaultTitle({
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
