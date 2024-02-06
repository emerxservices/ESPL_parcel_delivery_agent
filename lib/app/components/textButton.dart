import 'package:flutter/material.dart';
import '../utilities/constants.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {required this.onPress,
      required this.title,
      this.textStyle,
      this.overlayColor});

  VoidCallback onPress;
  String title;
  TextStyle? textStyle;
  Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(55)),
        overlayColor:
            MaterialStateProperty.all(overlayColor ?? orangeOverlayPrimary),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        )),
      ),
      child: Text(
        title,
        style: textStyle ?? kText18w700,
      ),
    );
  }
}
