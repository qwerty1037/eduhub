import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

/// Format of TextBox
///
/// Fluent UI에서 사용하는 TextField의 대용, TextBox의 양식
class DefaultTextBox extends StatelessWidget {
  const DefaultTextBox(
      {super.key,
      this.labelText,
      required this.placeholder,
      this.onChanged,
      this.controller,
      this.prefix,
      this.suffix,
      this.onEditingComplete,
      this.maxLines,
      this.minLines});

  final String? labelText;
  final String placeholder;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onEditingComplete;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextBox(
      placeholder: placeholder,
      highlightColor: Colors.transparent,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
    );
  }
}
