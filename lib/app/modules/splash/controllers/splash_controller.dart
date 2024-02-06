import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/booking_response.dart';
import 'package:espl_parcel_driver/app/models/online_status_response.dart';
import 'package:espl_parcel_driver/app/modules/splash/models/check_is_profile_set_response.dart';
import 'package:espl_parcel_driver/app/utilities/session_manager.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends NetworkClient {
  final count = 0.obs;

  RxBool isLoggedIn = false.obs;
  RxBool onlineStatus = false.obs;
  RxBool isOnGoingOrder = false.obs;
  // LocationServiceConnectivity locationServiceConnectivity = LocationServiceConnectivity();

  @override
  void onInit() {
    super.onInit();
    // locationServiceConnectivity.checkLocationService();
  }

  @override
  void onReady() {
    super.onReady();
    handleRouteChange();
    print("ONREADY CALLED");
  }

  @override
  void onClose() {
    print("ONCLOSE CALLED");
    super.onClose();
  }

  handleRouteChange() async {
    isLoggedIn.value = await SessionManager().getBoolean(SessionManager.isLogin);
    // Get.offAllNamed(Routes.LOGIN);

    if (isLoggedIn.value == true) {
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
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
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

  void increment() => count.value++;
}
