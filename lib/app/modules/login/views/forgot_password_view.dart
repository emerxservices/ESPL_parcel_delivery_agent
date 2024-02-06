import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customCardWidget.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class ForgotPasswordView extends GetView<LoginController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading.value == true
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
              title: 'forgotPassword2'.tr,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCardWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'emailAddress'.tr,
                              style: kText20w700.copyWith(color: orange),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextInputBox(
                              keyboardType: 'email',
                              placeHolder: 'enterYourEmailAddress'.tr,
                              onValueChange: (value) {
                                controller.emailInputController.text = value;

                                controller.emailAddress = value;
                              },
                              validationType: "email",
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 18.0),
                              child: Text(
                                'confirmForgotEmailDesc'.tr,
                                textAlign: TextAlign.center,
                                style: kText12w400.copyWith(
                                    color: inActiveGreyText),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      ButtonPrimary(
                        onPress: () {
                          print(controller.emailAddress);
                          // Get.to(() => ChangePassword());
                          controller.handleForgotPasswordSendOtp();
                        },
                        title: 'submit'.tr,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
            ),
          ));
  }
}
