import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customCardWidget.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/modules/login/controllers/login_controller.dart';

class OtpVerificationView extends GetView<LoginController> {
  const OtpVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loading.value == true
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: CustomMultiAppbar(
              title: 'otpVerification'.tr,
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
                              'enterOtpSentOnYourMobile'.tr,
                              style: kText16w400,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              'otp'.tr,
                              style: kText32w700.copyWith(color: orange),
                            ),
                            const SizedBox(
                              height: 30,
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
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (String pin) {
                                if (pin.length == 6) {
                                  controller.loginOtp = pin;
                                  print("Completed: " + pin);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       'didntReceivedOtp'.tr,
                            //       style: kText16w300.copyWith(color: darkBlue),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         // Navigator.push(context,
                            //         //     MaterialPageRoute(builder: (context) {
                            //         //   return ProfileSetup();
                            //         // }));
                            //         print("Resend code pressed ");
                            //       },
                            //       child: Text(
                            //         'resendCode'.tr,
                            //         style:
                            //             kText16w700.copyWith(color: darkBlue),
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      ButtonPrimary(
                        onPress: () {
                          if (controller.loginOtp?.length == 6) {
                            // veriFyOTP();
                            controller.verifyOtp();
                            print(
                                "Submit button pressed : ${controller.loginOtp}");
                          }
                        },
                        title: 'submit'.tr,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
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
                    ],
                  ),
                ),
              ),
            ),
          ));
  }
}
