import 'dart:io';

import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customBox.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/modules/profile_setup/controllers/profile_setup_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DrivingLicenseFrontImageView extends GetView<ProfileSetupController> {
  const DrivingLicenseFrontImageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: controller.backButtonPress,
      child: Scaffold(
        appBar: CustomMultiAppbar(
          title: "",
          onLeadingIconButtonPress: () {
            Get.back();
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'takeAPhotoOfYourLicenseFront'.tr,
              style: kText24w700,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight - 40),
                      child: Column(children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Obx(() => controller
                                .drivingLicenseImage.value.isNotEmpty
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      '$BASE_URL/${controller.drivingLicenseImage.value}',
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: darkBlue,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          controller.drivingLicenseImage.value =
                                              "";
                                          controller.temporaryImage.value = "";
                                          print("Close button pressed");
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : controller.temporaryImage.value.isNotEmpty
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          File(controller.temporaryImage.value),
                                          width: double.infinity,
                                          height: 220,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Positioned(
                                        top: -6,
                                        right: -6,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: darkBlue,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              controller.temporaryImage.value =
                                                  "";
                                              print("Close button pressed");
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : TextButton(
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Color(0xFFfff6f4)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    onPressed: () {
                                      controller.actionSheet
                                          .showActionSheet(context);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        const Image(
                                          image: AssetImage(
                                              'images/rectangle.png'),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Color(0xFFABB6BC),
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                              'uploadOrTakePhoto'.tr,
                                              style: kText18w700.copyWith(
                                                  color:
                                                      const Color(0xFFABB6BC)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                        const SizedBox(
                          height: 40.0,
                        ),
                        TextInputBox(
                          controller:
                              controller.drivingLicenseNumberInputController,
                          onValueChange: (value) {},
                          placeHolder: 'drivingLicenseNumber'.tr,
                        ),
                        const SizedBox(
                          height: 14.0,
                        ),
                        CustomBox(
                          child: Obx(() => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.licenseExpiryDate.value == ''
                                      ? Text(
                                          'expiryDate'.tr,
                                          style: kText14w400.copyWith(
                                              color: inActiveGreyText),
                                        )
                                      : Text(
                                          controller.licenseExpiryDate.value,
                                          style: kText14w400.copyWith(
                                              color: Colors.black),
                                        ),
                                  IconButton(
                                    onPressed: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now()
                                              .add(const Duration(days: 0)),
                                          lastDate: DateTime(2100),
                                          builder: (context, child) {
                                            return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary:
                                                        orange, // <-- SEE HERE
                                                    onPrimary: Colors
                                                        .white, // <-- SEE HERE
                                                    onSurface:
                                                        orange, // <-- SEE HERE
                                                  ),
                                                ),
                                                child: child!);
                                          }).then((value) {
                                        if (value == null) return;
                                        controller.licenseExpiryDate.value =
                                            DateFormat('yyyy-MM-d').format(
                                                DateTime.parse(
                                                    value!.toString()));
                                        controller
                                            .licenseExpiryDateInputController
                                            .text = DateFormat(
                                                'yyyy-MM-d')
                                            .format(DateTime.parse(
                                                value!.toString()));
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.calendar_month_outlined,
                                      color: darkBlue,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        ButtonPrimary(
                          onPress: () {
                            if (controller.licenseExpiryDateInputController
                                        .text !=
                                    '' &&
                                controller.drivingLicenseNumberInputController
                                        .text !=
                                    "") {
                              controller.handleDrivingLicenseDetails();
                            }
                          },
                          title: 'next'.tr,
                        )
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
