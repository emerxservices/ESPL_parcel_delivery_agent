import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/modules/profile_setup/controllers/profile_setup_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CongratulationsView extends GetView<ProfileSetupController> {
  const CongratulationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  height: MediaQuery.of(context).size.width * 0.32,
                  child: Image.asset("images/congratulations.png"),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                Text(
                  'congratulations'.tr,
                  style: kText32w700.copyWith(color: darkBlue),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'congratsMsg'.tr,
                  style: kText16w400.copyWith(color: lightGreySecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ButtonPrimary(
              onPress: () {
                // Get.offAll(() => Home());
                controller.goToHome();
              },
              title: 'goToHomePage'.tr,
            ),
          )
        ],
      ),
    ));
  }
}
