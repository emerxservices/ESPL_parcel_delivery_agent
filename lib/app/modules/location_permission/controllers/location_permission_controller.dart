import 'package:espl_parcel_driver/app/utilities/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import '../../../../services/api_endpoints.dart';
import '../../../../services/api_param.dart';
import '../../../../services/network_client.dart';
import '../../../components/customToast.dart';
import '../../../models/booking_response.dart';
import '../../../models/online_status_response.dart';
import '../../../routes/app_pages.dart';
import '../../login/models/check_is_profile_set_response.dart';

class LocationPermissionController extends NetworkClient
    with WidgetsBindingObserver {
  RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("+++++++++++++++++++ ${state} ++++++++++++++++++++++++");
    if (state == AppLifecycleState.resumed) {
      checkLocationEnabled();
    }
  }

  requestPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        perm.openAppSettings();
        return;
      }
    }
  }

  checkLocationEnabled() async {
    Location location = Location();

    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted &&
        await location.serviceEnabled() == true) {
      handleRouteChange();
    }
  }

  handleRouteChange() async {
    print("Here");
    isLoggedIn.value =
        await SessionManager().getBoolean(SessionManager.isLogin);
    // Get.offAllNamed(Routes.LOGIN);

    if (isLoggedIn.value == true) {
      if (await checkIsProfileSet() == true) {
        if (await checkIsOnline() == true &&
            await checkIsOngoingBooking() == true) {
          Get.offAllNamed(Routes.ONGOING_ORDER);
        } else if (await checkIsOnline() == true) {
          Get.offAllNamed(Routes.ALL_ORDERS);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.offAllNamed(Routes.PROFILE_SETUP);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  checkIsProfileSet() async {
    Map<String, Object> data = {};
    bool? isProfileSetResp = false;
    CheckIsProfileSetResponse checkIsProfileSetResponse;

    await get(ApiEndPoints.isDriverProfileSet, data).then((value) async {
      checkIsProfileSetResponse =
          checkIsProfileSetResponseFromJson(value.toString());

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
        IsOngoingBooking =
            (bookingsResponse.data?.totalcount)! > 0 ? true : false;
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
}
