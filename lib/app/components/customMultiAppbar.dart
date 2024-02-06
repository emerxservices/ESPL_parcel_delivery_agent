import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';

class CustomMultiAppbar extends StatelessWidget implements PreferredSizeWidget {
  CustomMultiAppbar(
      {this.leadingIcon,
      this.onLeadingIconButtonPress,
      required this.title,
      this.rightItemWidget,
      this.appBarBackgroundColor,
      this.appBarTextColor,
      this.appBarLeadingIconColor});

  String title;
  IconData? leadingIcon;
  VoidCallback? onLeadingIconButtonPress;
  Widget? rightItemWidget;
  Color? appBarBackgroundColor;
  Color? appBarTextColor;
  Color? appBarLeadingIconColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: appBarBackgroundColor != null
            ? appBarBackgroundColor
            : Colors.white,

        // Status bar brightness (optional)
        statusBarIconBrightness: appBarBackgroundColor != null
            ? Brightness.light
            : Brightness.dark, // For Android (dark icons)
        statusBarBrightness: appBarBackgroundColor != null
            ? Brightness.dark
            : Brightness.light, // For iOS (dark icons)
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor:
          appBarBackgroundColor != null ? appBarBackgroundColor : Colors.white,
      leading: IconButton(
        splashRadius: 20.0,
        icon: leadingIcon != null
            ? Icon(
                leadingIcon,
                size: 35,
                color: appBarLeadingIconColor != null
                    ? appBarLeadingIconColor
                    : black,
              )
            : Icon(
                Icons.chevron_left,
                size: 35,
                color: appBarLeadingIconColor != null
                    ? appBarLeadingIconColor
                    : black,
              ),
        onPressed: onLeadingIconButtonPress ??
            () {
              Navigator.pop(context);
            },
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            child: rightItemWidget,
          ),
        )
      ],
      title: Text(
        title,
        style: kText22w600.copyWith(
            color: appBarTextColor != null ? appBarTextColor : black),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Use this for customizing appbar

// leadingIcon: Icons.ice_skating_sharp,
// onLeadingIconButtonPress: () {
// print("Front icon pressed!");
// },
// title: 'Login',
// rightItemWidget: CircleAvatar(
// backgroundColor: Colors.grey,
// ),
