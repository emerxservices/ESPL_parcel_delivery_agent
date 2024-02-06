import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customCardWidget.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../controllers/profile_controller.dart';

class LoggedinVerifyChangePasswordView extends GetView<ProfileController> {
  LoggedinVerifyChangePasswordView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              title: 'changePassword'.tr,
            ),
            body: Form(
              key: _formKey,
              child: LayoutBuilder(
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
                                'otp'.tr,
                                style: kText20w700.copyWith(color: orange),
                              ),
                              OTPTextField(
                                length: 6,
                                // width: MediaQuery.of(context).size.width,
                                fieldWidth: 40,
                                outlineBorderRadius: 100.0,
                                otpFieldStyle: OtpFieldStyle(
                                  borderColor: orange,
                                  focusBorderColor: orangePrimary,
                                  enabledBorderColor: orange,
                                ),
                                style: TextStyle(fontSize: 17, color: orange),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                onChanged: (String pin) {
                                  if (pin.length == 6) {
                                    controller.otp = pin;
                                    print("Completed: " + pin);
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Obx(() => TextInputBox(
                                    controller:
                                        controller.newPasswordInputController,
                                    obscureText:
                                        controller.toggleTypeNewPassword.value,
                                    typePassword: true,
                                    eyeColor: inActiveGreyText,
                                    onEyePress: () {
                                      controller.toggleTypeNewPassword.value =
                                          !controller
                                              .toggleTypeNewPassword.value;
                                    },
                                    keyboardType: 'text',
                                    placeHolder: 'newPassword'.tr,
                                    onValueChange: (value) {
                                      print(value);
                                    },
                                    valueStyle: kText14w400.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    validationType: 'password',
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Obx(() => TextInputBox(
                                    controller: controller
                                        .confirmNewPasswordInputController,
                                    obscureText: controller
                                        .toggleTypeConfirmNewPassword.value,
                                    typePassword: true,
                                    eyeColor: inActiveGreyText,
                                    onEyePress: () {
                                      controller.toggleTypeConfirmNewPassword
                                              .value =
                                          !controller
                                              .toggleTypeConfirmNewPassword
                                              .value;
                                    },
                                    keyboardType: 'text',
                                    placeHolder: 'confirmPassword'.tr,
                                    onValueChange: (value) {
                                      print(value);
                                    },
                                    valueStyle: kText14w400.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18.0,
                        ),
                        ButtonPrimary(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              if (controller.otp?.length == 6) {
                                if (controller.confirmNewPasswordInputController
                                        .text !=
                                    controller
                                        .newPasswordInputController.text) {
                                  CustomToast.show(
                                      "Password and Confirm Password doesn't match");
                                } else {
                                  // controller.goToLogin();
                                  controller.handleChangePassword();
                                }
                              } else {
                                CustomToast.show("OTP is required");
                              }
                            }
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
            ),
          ));
  }
}
