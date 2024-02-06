import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppbar(
      {required this.onlineStatus,
      required this.onSwitchPress,
      required this.onLeadingIconPress,
      this.leadingIcon,
      required this.title});
  RxBool onlineStatus = false.obs;
  final Function(bool) onSwitchPress;
  final Function onLeadingIconPress;
  String title;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  Icon? leadingIcon;

  @override
  Widget build(BuildContext context) {
    print(title);
    return AppBar(
      forceMaterialTransparency: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: darkBluePrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      centerTitle: true,
      elevation: 0,
      leading: leadingIcon ??
          IconButton(
              onPressed: () {
               Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: black,
              )),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(
                'online'.tr,
                style: kText16w400,
              ),
              Obx(
                () => Switch(
                    value: onlineStatus.value,
                    activeColor: Colors.white54,
                    thumbColor: MaterialStateProperty.all(orange),
                    trackOutlineWidth: MaterialStateProperty.all(1),
                    trackColor: MaterialStateProperty.all(darkBluePrimary),
                    onChanged: (val) => onSwitchPress(val)),
              )
            ],
          ),
        )
      ],
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
