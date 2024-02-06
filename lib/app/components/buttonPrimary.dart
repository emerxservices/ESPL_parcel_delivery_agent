import 'package:flutter/material.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';

class ButtonPrimary extends StatelessWidget {
  ButtonPrimary(
      {required this.onPress,
      required this.title,
      this.backgroundColor,
      this.titleColor,
      this.customTextStyle});

  VoidCallback onPress;
  String title;
  Color? backgroundColor;
  Color? titleColor;
  TextStyle? customTextStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(55),
        backgroundColor: backgroundColor != null ? backgroundColor : orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      onPressed: onPress,
      child: Text(
        title,
        style: customTextStyle != null
            ? customTextStyle
            : titleColor != null
                ? kText20w700.copyWith(color: titleColor)
                : kText20w700.copyWith(color: Colors.white),
      ),
    );
  }
}
