import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/countryPicker.dart';
import 'package:espl_parcel_driver/app/components/customBox.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/Appbar.dart';
import '../../../components/customCardWidget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
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
              appBar: Appbar(),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Text(
                              //   AppLocalizations.of(context)!.letsStartWithYour,
                              //   style: kText20w700.copyWith(
                              //       fontWeight: FontWeight.w400),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              CustomCardWidget(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'mobileNumber'.tr,
                                      style:
                                          kText20w700.copyWith(color: orange),
                                    ),
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    Row(
                                      children: [
                                        CustomBox(
                                          child: CountryPicker(
                                            isShowDownIcon: true,
                                            // arrowDownIconColor: Colors.black,
                                            onCountryCodeChange: (value) {
                                              controller.countryCodeController
                                                  .text = value;
                                              // setState(() {
                                              controller.countryCode = value;
                                              // });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 14.0,
                                        ),
                                        Expanded(
                                          child: TextInputBox(
                                            controller: controller
                                                .numberInputController,
                                            keyboardType: 'number',
                                            placeHolder:
                                                'enterYourMobileNumber'.tr,
                                            onValueChange: (value) {
                                              // setState(
                                              //       () {
                                              controller.phoneNumber = value;
                                              //   },
                                              // );
                                            },
                                            validationType: "phoneNumber",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        'otpSentText'.tr,
                                        textAlign: TextAlign.center,
                                        style: kText12w400.copyWith(
                                            color: inActiveGreyText),
                                      ),
                                    )
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
                                        controller.goToSignup();

                                        // Get.to(() => RegistrationStepOne());
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
                                onPress: () {
                                  // Get.to(() => OtpVerification());
                                  if (_formKey.currentState!.validate()) {
                                    controller.sendOtp();
                                  }
                                },
                                title: 'login'.tr,
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              ButtonPrimary(
                                onPress: () {
                                  controller.resetControllerValue();
                                  controller.goToLoginWithEmail();
                                  // control.locationSubscription!.cancel();
                                },
                                title: 'loginWithEmailAddress'.tr,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 18.0),
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
