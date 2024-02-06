import 'package:espl_parcel_driver/app/components/customCardWidget.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/modules/login/controllers/login_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/buttonPrimary.dart';

class LoginWithEmailView extends GetView<LoginController> {
  LoginWithEmailView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading.value == true
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Form(
            key: _formKey,
            child: Scaffold(
              appBar: CustomMultiAppbar(
                title: 'Login'.tr,
                onLeadingIconButtonPress: () {
                  controller.resetControllerValue();
                  Get.back();
                },
              ),
              body: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              // Text(
                              //   AppLocalizations.of(context)!.welcomeText,
                              //   textAlign: TextAlign.center,
                              //   style: kText24w700,
                              // ),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              CustomCardWidget(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'emailAddress'.tr,
                                      style:
                                          kText20w700.copyWith(color: orange),
                                    ),
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    Column(
                                      children: [
                                        TextInputBox(
                                          keyboardType: 'email',
                                          placeHolder:
                                              'enterYourEmailAddress'.tr,
                                          onValueChange: (value) {
                                            controller.emailInputController
                                                .text = value;

                                            controller.emailAddress = value;
                                          },
                                          validationType: "email",
                                        ),
                                        const SizedBox(
                                          height: 14.0,
                                        ),
                                        Obx(() => TextInputBox(
                                              keyboardType: 'text',
                                              typePassword: true,
                                              obscureText: controller
                                                  .toggleTypePassword.value,
                                              onEyePress: () {
                                                controller.toggleTypePassword
                                                        .value =
                                                    !controller
                                                        .toggleTypePassword
                                                        .value;
                                              },
                                              placeHolder:
                                                  'enterYourPassword'.tr,
                                              onValueChange: (value) {
                                                controller
                                                    .passwordInputController
                                                    .text = value;
                                              },
                                              validationType: "password",
                                            )),
                                      ],
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(top: 18.0),
                                    //   child: Text(
                                    //     AppLocalizations.of(context)!
                                    //         .otpSentTextonEmailAddress,
                                    //     textAlign: TextAlign.center,
                                    //     style: kText12w400.copyWith(
                                    //         color: inActiveGreyText),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.goToForgotPassword();
                                      },
                                      child: Text(
                                        'forgotPassword'.tr,
                                        style: kText14w600.copyWith(
                                            color: lightBlue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'newUser'.tr,
                                      style:
                                          kText14w400.copyWith(color: darkBlue),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Get.to(() => RegistrationStepOne());
                                        controller.goToSignup();
                                      },
                                      child: Text(
                                        'signup'.tr,
                                        style:
                                            kText16w700.copyWith(color: orange),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ButtonPrimary(
                                titleColor: Colors.white,
                                onPress: () {
                                  // Get.offAll(() => Home());
                                  // controller.goToHome();
                                  if (_formKey.currentState!.validate()) {
                                    controller.loginWithEmail();
                                  }
                                },
                                title: 'login'.tr,
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 18.0),
                            child: RichText(
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
  }
}
