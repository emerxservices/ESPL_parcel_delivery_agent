import 'package:espl_parcel_driver/app/components/boxButtons.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return SafeArea(
      child: Obx(
        () => controller.loading == true
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  // height: MediaQuery.of(context).size.width * 0.5,
                                  child: Image.asset(
                                    "images/profileSetupImage.png",
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 40.0,
                            // ),
                            Obx(
                              () => Text(
                                "${'welcome'.tr}, ${controller.profileData.value['data']?['firstname']}!!",
                                // "${'welcome'.tr}, Desd!!",

                                style: kText24w700.copyWith(
                                    color: orange, fontSize: 28),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'requiredFewSteps'.tr,
                              style: kText18w700.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            BoxButtons(
                              title: 'vehicleRegistration'.tr,
                              goto: Routes.VEHICLE_REGISTRATION,
                              onUpdateProfileData: () =>
                                  controller.getProfileData(),
                              dataUploaded: controller.profileData.value['data']
                                          ?['vehicleno'] !=
                                      null
                                  ? true
                                  : false,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            BoxButtons(
                              title: 'drivingLicense'.tr,
                              goto: Routes.DRIVING_LICENSE_FRONT_IMAGE,
                              onUpdateProfileData: () =>
                                  controller.getProfileData(),
                              dataUploaded: controller.profileData.value['data']
                                              ?['licenseno'] !=
                                          null &&
                                      controller.profileData.value['data']
                                              ?['licenseexpirydate'] !=
                                          null &&
                                      controller.profileData.value['data']
                                              ?['licenceimagepath'] !=
                                          null
                                  ? true
                                  : false,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            if (controller.profileData.value['data']
                                        ?['licenseno'] !=
                                    null &&
                                controller.profileData.value['data']
                                        ?['licenseexpirydate'] !=
                                    null &&
                                controller.profileData.value['data']
                                        ?['licenceimagepath'] !=
                                    null &&
                                controller.profileData.value['data']
                                        ?['vehicleno'] !=
                                    null)
                              BoxButtons(
                                title: 'termsAndConditions'.tr,
                                goto: Routes.TERMS_AND_CONDITIONS,
                                dataUploaded: false,
                              ),
                            const SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 18.0),
                      //   child: RichText(
                      //     textAlign: TextAlign.center,
                      //     text: TextSpan(
                      //       style:
                      //           kText14w400.copyWith(color: darkBlue, height: 1.6),
                      //       children: [
                      //         TextSpan(
                      //           text: AppLocalizations.of(context)!.termsText1,
                      //         ),
                      //         TextSpan(
                      //           style: kText14w400.copyWith(
                      //               fontWeight: FontWeight.w500, color: lightBlue),
                      //           text: AppLocalizations.of(context)!.termsText2,
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                      //               print('Terms of Services');
                      //             },
                      //         ),
                      //         TextSpan(
                      //           text: AppLocalizations.of(context)!.termsText3,
                      //         ),
                      //         TextSpan(
                      //             style: kText14w400.copyWith(
                      //                 fontWeight: FontWeight.w500,
                      //                 color: lightBlue),
                      //             text: AppLocalizations.of(context)!.termsText4,
                      //             recognizer: TapGestureRecognizer()
                      //               ..onTap = () {
                      //                 print('Privacy Policy');
                      //               }),
                      //         TextSpan(
                      //           text: AppLocalizations.of(context)!.termsText5,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
