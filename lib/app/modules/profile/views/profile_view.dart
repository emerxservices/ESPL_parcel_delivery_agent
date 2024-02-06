import 'dart:io';

import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/countryPicker.dart';
import 'package:espl_parcel_driver/app/components/customBox.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.backButtonPress,
      child: Obx(() => controller.loadingData.value == true
          ? Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(
                  color: orangePrimary,
                ),
              ),
            )
          : Scaffold(
              appBar: CustomMultiAppbar(
                title: 'profile'.tr,
                onLeadingIconButtonPress: () {
                  controller.temporaryImage.value = '';
                  Get.back();
                },
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Obx(
                                  () => controller.temporaryImage.value == ""
                                      ? CircleAvatar(
                                          radius: 60.0,
                                          backgroundColor: greyShade1,
                                          backgroundImage: NetworkImage(
                                            '$BASE_URL${homeController.profileImage.value}',
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey.shade300,
                                          radius: 60.0,
                                          child: ClipOval(
                                            child: Image.file(
                                              File(controller
                                                  .temporaryImage.value),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                ),
                                Positioned(
                                    bottom: -14,
                                    right:
                                        MediaQuery.of(context).size.width / 2 -
                                            100,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        controller
                                            .showPickFromBottomSheet(context);
                                      },
                                      elevation: 2.0,
                                      fillColor: darkBlue,
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(7.0),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    )),
                              ],
                            ),
                            Seperator(),
                            Seperator(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextInputBox(
                                    enabled: false,
                                    controller:
                                        homeController.firstNameInputController,
                                    keyboardType: 'text',
                                    placeHolder: 'fName'.tr,
                                    onValueChange: (value) {
                                      print(value);
                                    },
                                    hintTextStyle: kText14w400.copyWith(
                                        color: Colors.black54, fontSize: 18),
                                    valueStyle: kText14w400.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Seperator(),

                            //Email Address
                            TextInputBox(
                              enabled: false,
                              controller: homeController.emailInputController,
                              keyboardType: 'email',
                              placeHolder: 'emailAddress'.tr,
                              onValueChange: (value) {
                                print(value);
                              },
                              hintTextStyle: kText14w400.copyWith(
                                  color: Colors.black54, fontSize: 18),
                              valueStyle: kText14w400.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Seperator(),

                            //Password
                            Stack(
                              children: [
                                TextInputBox(
                                  enabled: false,
                                  controller:
                                      controller.passwordInputController,
                                  keyboardType: 'text',
                                  placeHolder: "*******",
                                  // AppLocalizations.of(context)!.password,
                                  onValueChange: (value) {
                                    print(value);
                                  },
                                  hintTextStyle: kText14w400.copyWith(
                                      color: Colors.black, fontSize: 18),
                                  valueStyle: kText14w400.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                          Routes.LOGGEDIN_CHANGE_PASSWORD);
                                    },
                                    child: Text(
                                      'changePassword2'.tr,
                                      style: kText16w700.copyWith(
                                          color: lightBlue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Seperator(),

                            //phone Number
                            Row(
                              children: [
                                CustomBox(
                                  child: Row(
                                    children: [
                                      AbsorbPointer(
                                        child: CountryPicker(
                                          initialSelection: homeController
                                              .countryCodeController.text,
                                          isShowDownIcon: true,
                                          arrowDownIconColor: Colors.black54,
                                          onCountryCodeChange: (value) {
                                            controller.countryCodeController
                                                .text = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: TextInputBox(
                                    enabled: false,
                                    controller:
                                        homeController.numberInputController,
                                    keyboardType: 'number',
                                    placeHolder: 'phoneNumber'.tr,
                                    onValueChange: (value) {
                                      print(value);
                                    },
                                    hintTextStyle: kText14w400.copyWith(
                                        color: Colors.black54, fontSize: 18),
                                    valueStyle: kText14w400.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Seperator(),
                            OptionButton(
                              onTap: () {
                                showAlertDialog(context);
                              },
                              title: 'deleteAccount'.tr,
                              description: 'deleteAccountDesc'.tr,
                            ),
                          ],
                        ),
                        // Seperator(),
                        Seperator(),
                        ButtonPrimary(
                          onPress: () {
                            controller.updateProfileImage();
                          },
                          title: 'saveChanges'.tr,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        'cancel'.tr,
      ),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: Text('confirm'.tr),
      onPressed: () {
        Get.back();
        controller.deleteAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('deleteAccount'.tr),
      content: Text('areYouSureYouWantToDeleteYourAccount'.tr),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class OptionButton extends StatelessWidget {
  OptionButton({
    required this.onTap,
    required this.title,
    required this.description,
    super.key,
  });

  VoidCallback onTap;
  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: inActiveGrey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kText16w700.copyWith(color: Color(0xFF012B49)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  description,
                  style: kText14w400.copyWith(color: inActiveGreyText),
                )
              ],
            ),
            Icon(Icons.arrow_forward_ios_outlined),
          ],
        ),
      ),
    );
  }
}

class Seperator extends StatelessWidget {
  const Seperator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
    );
  }
}
