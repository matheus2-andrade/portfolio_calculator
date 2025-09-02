import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final double height;
  final double width;
  final String? text;
  final Icon? icon;
  final Color? buttonColor;
  final Color? contentColor;
  final VoidCallback? onPressed;

  const SmallButton({
    super.key,
    this.height = 62,
    this.width = 62,
    this.text,
    this.icon,
    this.buttonColor,
    this.contentColor,
    this.onPressed,
  }) : assert(
         (text != null) ^ (icon != null),
         'Você deve passar APENAS um parâmetro: "text" OU "icon".',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: buttonColor != null
              ? WidgetStateProperty.all(buttonColor)
              : null,
          foregroundColor: contentColor != null
              ? WidgetStateProperty.all(contentColor)
              : null,
        ),
        child:
            icon ??
            Text(
              text!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: contentColor),
            ),
      ),
    );
  }
}
