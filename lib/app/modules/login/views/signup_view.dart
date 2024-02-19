import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/countryPicker.dart';
import 'package:espl_parcel_driver/app/components/customBox.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/modules/login/controllers/login_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SignupView extends GetView<LoginController> {
  SignupView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading == true
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: orange,
              ),
            ),
          )
        : Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomMultiAppbar(
                title: 'registration'.tr,
                onLeadingIconButtonPress: () {
                  controller.resetControllerValue();
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'youAreJust'.tr,
                          style:
                              kText20w700.copyWith(fontWeight: FontWeight.w400),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 14.0, bottom: 20.0),
                          child: Text(
                            'oneStepAway'.tr,
                            style: kText32w700.copyWith(color: orange),
                          ),
                        ),
                        //First name lastname
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextInputBox(
                                controller: controller.firstNameInputController,
                                keyboardType: 'text',
                                placeHolder: 'fName'.tr,
                                onValueChange: (value) {
                                  // print(value);
                                },
                                valueStyle: kText14w400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                validationType: 'firstName',
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: TextInputBox(
                                controller: controller.lastNameInputController,
                                keyboardType: 'text',
                                placeHolder: 'lName'.tr,
                                onValueChange: (value) {
                                  print(value);
                                },
                                valueStyle: kText14w400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                validationType: 'lastName',
                              ),
                            ),
                          ],
                        ),
                        Seperator(),
                        //Email Address
                        TextInputBox(
                          controller: controller.emailInputController,
                          keyboardType: 'email',
                          placeHolder: 'emailAddress'.tr,
                          onValueChange: (value) {
                            print(value);
                          },
                          valueStyle: kText14w400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          validationType: 'email',
                        ),
                        Seperator(),
                        //Phone number
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomBox(
                              child: Row(
                                children: [
                                  CountryPicker(
                                    isShowDownIcon: true,
                                    arrowDownIconColor: inActiveGreyText,
                                    onCountryCodeChange: (value) {
                                      controller.countryCodeController.text =
                                          value;
                                      print(value);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: TextInputBox(
                                controller: controller.numberInputController,
                                keyboardType: 'number',
                                placeHolder: 'phoneNumber'.tr,
                                onValueChange: (value) {
                                  print(value);
                                },
                                valueStyle: kText14w400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                validationType: 'phoneNumber',
                              ),
                            )
                          ],
                        ),
                        Seperator(),
                        //Country
                        TextInputBox(
                          controller: controller.countryInputController,
                          keyboardType: 'text',
                          placeHolder: 'country'.tr,
                          onValueChange: (value) {
                            print(value);
                          },
                          valueStyle: kText14w400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          validationType: '',
                        ),
                        Seperator(),

                        //Password
                        Obx(() => TextInputBox(
                              controller: controller.passwordInputController,
                              obscureText: controller.toggleTypePassword.value,
                              typePassword: true,
                              eyeColor: inActiveGreyText,
                              onEyePress: () {
                                controller.toggleTypePassword.value =
                                    !controller.toggleTypePassword.value;
                              },
                              keyboardType: 'text',
                              placeHolder: 'password'.tr,
                              onValueChange: (value) {
                                print(value);
                              },
                              valueStyle: kText14w400.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              validationType: 'password',
                            )),
                        Seperator(),

                        //Confirm Password
                        Obx(() => TextInputBox(
                              controller:
                                  controller.confirmPasswordInputController,
                              obscureText:
                                  controller.toggleTypeConfirmPassword.value,
                              typePassword: true,
                              eyeColor: inActiveGreyText,
                              onEyePress: () {
                                controller.toggleTypeConfirmPassword.value =
                                    !controller.toggleTypeConfirmPassword.value;
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
                        const SizedBox(
                          height: 50,
                        ),

                        //Long text with link
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: kText14w400.copyWith(
                                color: darkBlue, height: 1.6),
                            children: [
                              TextSpan(
                                text: 'termsText1'.tr,
                              ),
                              TextSpan(
                                style: kText14w400.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: lightBlue),
                                text: 'termsText2'.tr,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Terms of Services');
                                  },
                              ),
                              TextSpan(
                                text: 'termsText3'.tr,
                              ),
                              TextSpan(
                                  style: kText14w400.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: lightBlue),
                                  text: 'termsText4'.tr,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('Privacy Policy');
                                    }),
                              TextSpan(
                                text: 'termsText5'.tr,
                              ),
                            ],
                          ),
                        ),
                        //Button
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: ButtonPrimary(
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  controller
                                      .validatePassword(controller.register());
                                  print('Pressed registration page 1');
                                }
                              },
                              title: 'done'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
  }
}

class Seperator extends StatelessWidget {
  const Seperator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16.0,
    );
  }
}
