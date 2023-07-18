import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField(
      {super.key,
      this.labelText,
      required this.hintText,
      this.onChanged,
      this.controller,
      this.onEditingComplete,
      this.maxLines,
      this.minLines});

  final String? labelText;
  final String hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      onChanged: onChanged,
      controller: controller,
      onEditingComplete: onEditingComplete,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
