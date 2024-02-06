import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';

class SidemenuItem extends StatelessWidget {
  SidemenuItem({required this.title, required this.goto, this.icon});

  final String title;
  String goto;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Transform.translate(
          offset: Offset(-16, 0),
          child: Text(
            title,
            style: kText18w700,
          ),
        ),
        leading: Icon(
          icon,
          color: orangePrimary,
          size: 24,
        ),
        onTap: () {
          Get.toNamed(goto);
        },
      ),
    );
  }
}
