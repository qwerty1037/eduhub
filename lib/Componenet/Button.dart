import 'package:front_end/Componenet/Config.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  String text;
  bool isEnabled;
  ButtonType type;
  Icon? icon;
  VoidCallback? onPressed;
  final ButtonStyle textButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0))));
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      backgroundColor: DEFAULT_BUTTON_COLOR,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0))));
  final ButtonStyle outlinedButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0))));
  Button(
      {super.key,
      this.text = 'button',
      this.isEnabled = true,
      this.type = ButtonType.elevated,
      this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.elevated) {
      if (icon == null) {
        return ElevatedButton(
          onPressed: onPressed,
          style: elevatedButtonStyle,
          child: Text(
            text,
            style: const TextStyle(color: DEFAULT_LIGHT_COLOR),
          ),
        );
      } else {
        return ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(text,
                style: const TextStyle(
                    color: DEFAULT_LIGHT_COLOR,
                    fontSize: DEFAULT_BUTTON_FONT_SIZE)),
            style: elevatedButtonStyle);
      }
    } else if (type == ButtonType.outlined) {
      if (icon == null) {
        return OutlinedButton(
          onPressed: onPressed,
          style: outlinedButtonStyle,
          child: Text(
            text,
            style: const TextStyle(color: DEFAULT_BUTTON_COLOR),
          ),
        );
      } else {
        return OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(text,
                style: const TextStyle(
                    color: DEFAULT_BUTTON_COLOR,
                    fontSize: DEFAULT_BUTTON_FONT_SIZE)),
            style: elevatedButtonStyle);
      }
    } else {
      if (icon == null) {
        return TextButton(
          onPressed: onPressed,
          style: textButtonStyle,
          child: Text(
            text,
            style: const TextStyle(color: DEFAULT_BUTTON_COLOR),
          ),
        );
      } else {
        return TextButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(text,
                style: const TextStyle(
                    color: DEFAULT_BUTTON_COLOR,
                    fontSize: DEFAULT_BUTTON_FONT_SIZE)),
            style: textButtonStyle);
      }
    }
  }
}

enum ButtonType { elevated, outlined, text }
