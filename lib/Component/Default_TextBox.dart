import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

class DefaultTextBox extends StatelessWidget {
  const DefaultTextBox({this.labelText, required this.placeholder, this.onChanged, this.controller, this.prefix, this.suffix, this.onEditingComplete});

  final String? labelText;
  final String placeholder;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return TextBox(
      placeholder: placeholder,
      highlightColor: Colors.transparent,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      controller: controller,
      suffix: suffix,
      prefix: prefix,
    );
  }
}
