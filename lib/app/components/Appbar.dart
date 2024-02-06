import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utilities/constants.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: orangePrimary,

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Container(),
      title: Text(
        'login'.tr,
        style: kText22w600.copyWith(color: black),
      ),
    );
  }
}
