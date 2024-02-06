import 'package:flutter/material.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';

class CustomBox extends StatelessWidget {
  CustomBox({required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 55.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1, color: inActiveGrey)),
      child: child,
    );
  }
}
