import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  CustomCardWidget({required this.child});
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: child,
      ),
    );
  }
}
