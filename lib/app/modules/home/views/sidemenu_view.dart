import 'package:espl_parcel_driver/app/components/sidemenuItem.dart';
import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 230,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('images/drawerHeader.png'),
                //   fit: BoxFit.fill,
                // ),
                color: orange,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 40.0,
                      backgroundImage: NetworkImage(
                          '$BASE_URL${controller.profileImage.value}'),
                    ),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.grey.shade300,
                  //   radius: 40.0,
                  //   backgroundImage: const NetworkImage(
                  //       "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                  // ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.firstNameInputController.text} ${controller.lastNameInputController.text}',
                              // "Desmond miles",
                              style: kText18w700.copyWith(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              '${controller.countryCodeController.text}${controller.numberInputController.text}',
                              style: kText16w400.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 50,
                          // splashRadius: 20.0,
                          onPressed: () {
                            // Get.to(() => Profile());
                            Get.toNamed(Routes.PROFILE);
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //Bottom list item
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        SidemenuItem(
                          goto: Routes.MY_ORDERS,
                          title: 'myOrders'.tr,
                          icon: Icons.history,
                        ),
                        SidemenuItem(
                          goto: Routes.MY_EARNINGS,
                          title: 'myEarnings'.tr,
                          icon: Icons.attach_money,
                        ),
          
                        SidemenuItem(
                          goto: Routes.NOTIFICATIONS,
                          title: 'notification'.tr,
                          icon: Icons.notifications_none,
                        ),
                        // SizedBox(
                        //   child: Container(
                        //     height: 1,
                        //     color: Color(0xFFCCCCCC),
                        //   ),
                        // ),
                        // SidemenuItem(
                        //   goto: Settings(),
                        //   title: AppLocalizations.of(context)!.settings,
                        //   icon: Icons.settings,
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Transform.translate(
                        offset: Offset(-16, 0),
                        child: Text(
                          "logout".tr,
                          style: kText18w700,
                        ),
                      ),
                      leading: const Icon(
                        Icons.logout,
                        color: orangePrimary,
                        size: 24,
                      ),
                      onTap: () {
                        controller.onLogout();
                      },
                    ),
                  )
                  // GestureDetector(
                  //   onTap: () {
                  //     controller.onLogout();
                  //
                  //     // onLogout();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(18.0),
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(
                  //           stops: [0.025, 0.025],
                  //           colors: [orangePrimary, lightOrange]),
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(5.0),
                  //         bottomLeft: Radius.circular(5.0),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'logout'.tr,
                  //       style: kText18w700,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
