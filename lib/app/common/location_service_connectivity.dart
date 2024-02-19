import 'dart:async';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../services/api_endpoints.dart';
import '../../services/api_param.dart';
import '../components/customToast.dart';
import '../models/booking_response.dart';
import '../models/online_status_response.dart';
import '../modules/login/models/check_is_profile_set_response.dart';
import '../routes/app_pages.dart';
import '../utilities/session_manager.dart';

class LocationServiceConnectivity extends NetworkClient {
  //Service Connectivity
  RxBool isLoggedIn = false.obs;
  void checkLocationService() async {
    print("======================================");

    bool isServiceEnabled;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    //Initialise service stream
    StreamSubscription<ServiceStatus> serviceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        print("Service Disabled");
        Get.offAllNamed(Routes.LOCATION_PERMISSION);
      } else if (status == ServiceStatus.enabled) {
        print("ServiceStatus.enabled");
        handleRouteChange();
      }
    });
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

    print('=====================================');

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
