import 'dart:async';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/booking_response.dart';
import 'package:espl_parcel_driver/app/models/emptyResponse.dart';
import 'package:espl_parcel_driver/app/models/online_status_response.dart';
import 'package:espl_parcel_driver/app/modules/login/models/check_is_profile_set_response.dart';
import 'package:espl_parcel_driver/app/modules/login/models/forgot_password_response.dart';
import 'package:espl_parcel_driver/app/modules/login/models/registration_response.dart';
import 'package:espl_parcel_driver/app/modules/login/models/send_otp_response.dart';
import 'package:espl_parcel_driver/app/modules/login/models/verify_otp_response.dart';
import 'package:espl_parcel_driver/app/utilities/session_manager.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../../services/pushNotification.dart';

class LoginController extends NetworkClient {
  final count = 0.obs;
  String? phoneNumber;
  String countryCode = '+1';
  String? emailAddress;
  String? otp;
  String? loginOtp;
  RxBool toggleTypeNewPassword = true.obs;
  RxBool toggleTypeConfirmNewPassword = true.obs;
  RxBool toggleTypePassword = true.obs;
  RxBool toggleTypeConfirmPassword = true.obs;
  RxBool loading = false.obs;
  RxBool onlineStatus = false.obs;
  RxBool isOnGoingOrder = false.obs;
  TextEditingController numberInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController confirmPasswordInputController = TextEditingController();
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController countryInputController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController(text: "+1");
  TextEditingController newPasswordInputController = TextEditingController();
  TextEditingController confirmNewPasswordInputController = TextEditingController();

  @override
  Future<void> onInit() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    try {
      print(settings.authorizationStatus);
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional ||
          settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        print(settings.authorizationStatus);
        final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
        await PushNotification.initialize(flutterLocalNotificationsPlugin);
        // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      } else {
        print('settings.authorizationStatus ==> ${settings.authorizationStatus}');

        CustomToast.show("Notification permission denied! Allow notification permission to get notifications from LuxuryFastRide-Driver");
        Timer(Duration(seconds: 4), () async {
          openAppSettings();
        });
      }
    } catch (e) {
      print(e);
    }
    super.onInit();
  }

  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   print('A bg message just showed up :  ${message.messageId}');
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);
  void goToChangePassword() => Get.toNamed(Routes.CHANGE_PASSWORD);
  void goToLogin() => Get.close(2);
  void goToLoginWithEmail() => Get.toNamed(Routes.LOGIN_WITH_EMAIL);
  void goToOtpVerification() => Get.toNamed(Routes.OTP_VERIFICATION);
  void goToSignup() => Get.toNamed(Routes.SIGNUP);
  void goToProfileSetup() => Get.offAllNamed(Routes.PROFILE_SETUP);
  void goToHome() => Get.offAllNamed(Routes.HOME);

  void resetControllerValue() {
    numberInputController.text = "";
    emailInputController.text = "";
    passwordInputController.text = "";
    confirmPasswordInputController.text = "";
    firstNameInputController.text = "";
    lastNameInputController.text = "";
    countryInputController.text = "";
    countryCodeController.text = "+1";
    newPasswordInputController.text = "";
    confirmNewPasswordInputController.text = "";
  }

  validatePassword(VoidCallback function) {
    if (passwordInputController.text.isEmpty ||
        passwordInputController.text.isEmpty) {
      CustomToast.show('All fields are compulsory');
    } else if (passwordInputController.text != confirmPasswordInputController.text) {
      CustomToast.show('Password and confirm password doesn\'t match');
    } else {
      function; // Get.back();
    }
  }

  register() async {
    Map<String, Object> data = {};
    data[ApiParams.firstname] = firstNameInputController.text.toString();
    data[ApiParams.lastname] = lastNameInputController.text.toString();
    data[ApiParams.email] = emailInputController.text.toString();
    data[ApiParams.countrycode] = countryCodeController.text.toString();
    data[ApiParams.phone] = numberInputController.text.toString();
    data[ApiParams.password] = confirmPasswordInputController.text.toString();

    RegistrationResponse registrationResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.createDriver, data).then((value) {
      registrationResponse = registrationResponseFromJson(value.toString());

      if (registrationResponse.status == 200) {
        loading.value = false;

        (SessionManager().setInt(SessionManager.USERID, registrationResponse.data?.driverid ?? 0));
        (SessionManager().setString(SessionManager.userToken, registrationResponse.data?.token ?? ""));
        (SessionManager().setBoolean(SessionManager.isLogin, true));

        print("DriverId : ${registrationResponse.data?.driverid}");
        resetControllerValue();
        goToProfileSetup();
      } else {
        loading.value = false;
        print(registrationResponse.message);
        CustomToast.show(registrationResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  sendOtp() async {
    Map<String, Object> data = {};
    data[ApiParams.countrycode] = countryCodeController.text.toString();
    data[ApiParams.phone] = numberInputController.text.toString();

    SendOtpResponse sendOtpResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.sendDriverOtp, data).then((value) {
      sendOtpResponse = sendOtpResponseFromJson(value.toString());

      if (sendOtpResponse.status == 200) {
        loading.value = false;
        goToOtpVerification();
      } else {
        loading.value = false;
        print(sendOtpResponse.message);
        CustomToast.show(sendOtpResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  verifyOtp() async {
    Map<String, Object> data = {};
    data[ApiParams.countrycode] = countryCodeController.text.toString();
    data[ApiParams.phone] = numberInputController.text.toString();
    data[ApiParams.otp] = loginOtp.toString();

    VerifyOtpResponse verifyOtpResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.verifyDriverOtp, data).then((value) async {
      verifyOtpResponse = verifyOtpResponseFromJson(value.toString());

      if (verifyOtpResponse.status == 200) {
        loading.value = false;
        (SessionManager().setInt(SessionManager.USERID, verifyOtpResponse.data?.driverid ?? 0));
        (SessionManager().setString(SessionManager.userToken, verifyOtpResponse.data?.token ?? ""));
        (SessionManager().setBoolean(SessionManager.isLogin, true));

        if (await checkIsProfileSet() == true) {
          if (await checkIsOnline() == true && await checkIsOngoingBooking() == true) {
            Get.offAllNamed(Routes.ONGOING_ORDER);
          } else if (await checkIsOnline() == true) {
            Get.offAllNamed(Routes.ALL_ORDERS);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.offAllNamed(Routes.PROFILE_SETUP);
        }

        print("verifyOtpResponse : ${verifyOtpResponse.data?.firstname}");
      } else {
        loading.value = false;
        print(verifyOtpResponse.message);
        CustomToast.show(verifyOtpResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  checkIsProfileSet() async {
    Map<String, Object> data = {};
    bool? isProfileSetResp = false;
    CheckIsProfileSetResponse checkIsProfileSetResponse;

    await get(ApiEndPoints.isDriverProfileSet, data).then((value) async {
      checkIsProfileSetResponse = checkIsProfileSetResponseFromJson(value.toString());

      if (checkIsProfileSetResponse.status == 200) {
        isProfileSetResp = checkIsProfileSetResponse.data?.diverProfileIsSet;
        print(checkIsProfileSetResponse.data?.diverProfileIsSet);
        return isProfileSetResp;
      } else {
        CustomToast.show(checkIsProfileSetResponse.message!);
        return false;
      }
    }).catchError((onError) {
      print(onError);
    });

    return isProfileSetResp;
  }

  checkIsOnline() async {
    Map<String, Object> data = {};
    bool? checkIsOnlineResp = false;
    OnlineStatusResponse onlineStatusResponse;

    await get(ApiEndPoints.getOnlineStatus, data).then((value) {
      onlineStatusResponse = onlineStatusResponseFromJson(value.toString());

      if (onlineStatusResponse.status == 200) {
        checkIsOnlineResp = onlineStatusResponse.data?.onduty;
      } else {
        CustomToast.show(onlineStatusResponse.message!);
        checkIsOnlineResp = false;
      }
    }).catchError((onError) {
      print(onError);
    });

    return checkIsOnlineResp;
  }

  checkIsOngoingBooking() async {
    bool? IsOngoingBooking = false;

    Map<String, Object> data = {};
    data[ApiParams.status] = "Active";
    data[ApiParams.skip] = 0;
    data[ApiParams.limit] = 3;
    BookingsResponse bookingsResponse;

    await post(ApiEndPoints.driverBookings, data).then((value) async {
      bookingsResponse = bookingsResponseFromJson(value.toString());

      if (bookingsResponse.status == 200) {
        IsOngoingBooking = (bookingsResponse.data?.totalcount)! > 0 ? true : false;
        print(bookingsResponse.data?.bookings);
        return IsOngoingBooking;
      } else {
        CustomToast.show(bookingsResponse.message!);
        return false;
      }
    }).catchError((onError) {
      print(onError);
    });

    return IsOngoingBooking;
  }

  loginWithEmail() async {
    Map<String, Object> data = {};
    data[ApiParams.email] = emailInputController.text.toString();
    data[ApiParams.password] = passwordInputController.text.toString();

    VerifyOtpResponse verifyOtpResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.driverAuthenticate, data).then((value) async {
      verifyOtpResponse = verifyOtpResponseFromJson(value.toString());

      if (verifyOtpResponse.status == 200) {
        loading.value = false;
        (SessionManager().setInt(SessionManager.USERID, verifyOtpResponse.data?.driverid ?? 0));
        (SessionManager().setString(SessionManager.userToken, verifyOtpResponse.data?.token ?? ""));
        (SessionManager().setBoolean(SessionManager.isLogin, true));

        if (await checkIsProfileSet() == true) {
          if (await checkIsOnline() == true && await checkIsOngoingBooking() == true) {
            Get.offAllNamed(Routes.ONGOING_ORDER);
          } else if (await checkIsOnline() == true) {
            Get.offAllNamed(Routes.ALL_ORDERS);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.offAllNamed(Routes.PROFILE_SETUP);
        }

        print("verifyOtpResponse : ${verifyOtpResponse.data?.firstname}");
      } else {
        loading.value = false;
        print(verifyOtpResponse.message);
        CustomToast.show(verifyOtpResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  handleForgotPasswordSendOtp() async {
    Map<String, Object> data = {};
    data[ApiParams.email] = emailInputController.text.toString();

    ForgotPasswordResponse forgotPasswordResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.driverForgotPwdSendOtp, data).then((value) async {
      forgotPasswordResponse = forgotPasswordResponseFromJson(value.toString());

      if (forgotPasswordResponse.status == 200) {
        loading.value = false;

        goToChangePassword();
      } else {
        loading.value = false;
        print(forgotPasswordResponse.message);
        CustomToast.show(forgotPasswordResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  handleChangePassword() async {
    Map<String, Object> data = {};
    data[ApiParams.email] = emailInputController.text.toString();
    data[ApiParams.otp] = otp.toString();
    data[ApiParams.password] = newPasswordInputController.text.toString();

    EmptyResponse emptyResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.driverChangePassword, data).then((value) async {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        loading.value = false;
        CustomToast.show(emptyResponse.message!);
        resetControllerValue();
        Get.close(2);
      } else {
        loading.value = false;
        print(emptyResponse.message);
        CustomToast.show(emptyResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  void increment() => count.value++;
}
