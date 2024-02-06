import 'package:flutter/material.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/services.dart';

class TextInputBox extends StatelessWidget {
  TextInputBox(
      {required this.onValueChange,
      required this.placeHolder,
      this.keyboardType,
      this.typePassword,
      this.onEyePress,
      this.obscureText,
      this.hintTextStyle,
      this.valueStyle,
      this.eyeColor,
      this.controller,
      this.validationType,
      this.enabled});

  final Function onValueChange;
  final String placeHolder;
  String? keyboardType;
  bool? typePassword;
  bool? obscureText;
  VoidCallback? onEyePress;
  dynamic hintTextStyle;
  dynamic valueStyle;
  Color? eyeColor;
  TextEditingController? controller;
  String? validationType;
  bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      obscureText: obscureText ?? false,
      style: valueStyle != null
          ? valueStyle
          : kText14w400.copyWith(fontWeight: FontWeight.w600),
      maxLines: 1,
      keyboardType: keyboardType == 'number'
          ? TextInputType.number
          : keyboardType == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: kTextInputDecoration.copyWith(
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: inActiveGrey,
              width: 1.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: inActiveGreyText,
              width: 1.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: inActiveGrey,
              width: 1.0,
            ),
          ),
          errorStyle: const TextStyle(color: primaryRed ?? Colors.red),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryRed,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryRed,
              width: 1.0,
            ),
          ),
          errorMaxLines: 2,
          hintText: placeHolder,
          hintStyle:
              hintTextStyle ?? kText14w400.copyWith(color: inActiveGreyText),
          suffixIcon: typePassword == true
              ? IconButton(
                  onPressed: onEyePress,
                  icon: Icon(
                    obscureText == true
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: eyeColor != null ? eyeColor : Colors.grey,
                  ),
                )
              : null),
      onChanged: (value) {
        onValueChange(value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (validationType == 'firstName') {
          if (!RegExp(r"^[A-Za-z]+$").hasMatch(value ?? "")) {
            print("l70");
            return 'Enter a valid firstname';
          } else {
            return null;
          }
        } else if (validationType == 'lastName') {
          if (!RegExp(r"^[A-Za-z]+$").hasMatch(value ?? "")) {
            return 'Enter a valid lastname';
          } else {
            return null;
          }
        } else if (validationType == 'email') {
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value ?? "")) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        } else if (validationType == 'phoneNumber') {
          if ((value ?? "").length != 10) {
            return 'Enter a valid mobile number';
          } else {
            return null;
          }
        } else if (validationType == 'password') {
          if ((value ?? "").length < 8) {
            return 'Enter a valid password. Password must be of minimum 8 characters.';
          } else {
            return null;
          }
        } else if (validationType == 'vehicleRegNo') {
          if ((value ?? "").length < 4) {
            return 'Enter a valid vehicle registration number';
          } else {
            return null;
          }
        }
      },
    );
  }
}
