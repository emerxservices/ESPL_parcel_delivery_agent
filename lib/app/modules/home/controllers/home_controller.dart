import 'dart:async';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/booking_response.dart';
import 'package:espl_parcel_driver/app/models/emptyResponse.dart';
import 'package:espl_parcel_driver/app/models/get_profile_response.dart';
import 'package:espl_parcel_driver/app/models/online_status_response.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/session_manager.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../common/location_service_connectivity.dart';

class HomeController extends NetworkClient {
  final count = 0.obs;
  RxBool onlineStatus = false.obs;
  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;
  RxBool mapCreated = false.obs;
  RxString headerTitle = "home".tr.obs;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  BitmapDescriptor? CurrentLocationMarkerIcon;
  StreamSubscription<LocationData>? locationSubscription;
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController countryCodeController =
      TextEditingController(text: "+1");
  TextEditingController numberInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  RxString profileImage = ''.obs;
  RxString temporaryImage = ''.obs;
  RxList<Bookings> bookings = <Bookings>[].obs;
  RxBool loading = false.obs;
  final scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;
  RxInt skip = 0.obs;
  RxBool loadingData = false.obs;
  RxBool isFirstTimeLodingData = true.obs;
  RxInt totalCount = 0.obs;
  RxBool profileApprovedByAdmin = true.obs;
  RxInt locationUpdateCounter = 0.obs;
  LocationServiceConnectivity locationServiceConnectivity =
      LocationServiceConnectivity();

  @override
  void onInit() {
    super.onInit();
    locationServiceConnectivity.checkLocationService();
    getOnlineStatus();
    //Location
    requestPermission();
    DateTime dateTime = DateTime.now();
    print("Timezone ---- ${dateTime.timeZoneName}");
    print("Zone Offse---- ${dateTime.timeZoneOffset}");

    setPickupIcon();
    updateFCMToken();
    getProfileData();
    scrollController.addListener(_scrollListener);
    print('initCalled');
    loadingData.value = true;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    if (mapCreated.value == true) {
      mapController.dispose();
    }
    // locationSubscription?.cancel();
    super.onClose();
    print("dispose");
  }

  void _scrollListener() {
    if (isLoadingMore.value) return;
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        skip.value <= totalCount.value) {
      isLoadingMore.value = true;

      skip.value = skip.value + 3;
      getBookings('New', skip.value);

      isLoadingMore.value = false;
    }
  }

  getBookings(String status, int skip) async {
    if (isFirstTimeLodingData.value == true) {
      loadingData.value = false;
      isFirstTimeLodingData.value = false;
    }
    Map<String, Object> data = {};
    data[ApiParams.status] = status;
    data[ApiParams.skip] = skip;
    data[ApiParams.limit] = 3;

    BookingsResponse bookingsResponse;

    post(ApiEndPoints.driverBookings, data).then((value) {
      bookingsResponse = bookingsResponseFromJson(value.toString());

      if (bookingsResponse.status == 200) {
        bookingsResponse.data?.bookings?.forEach((item) {
          bookings.add(item);
        });
        totalCount.value = (bookingsResponse.data?.totalcount)!;
        loadingData.value = false;
      } else {
        CustomToast.show(bookingsResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  resetBooking() {
    bookings.value = [];
    skip.value = 0;
    getBookings("New", skip.value);
  }

  getProfileData() async {
    loading.value = true;
    Map<String, Object> data = {};

    GetProfileResponse getProfileResponse;

    get(ApiEndPoints.getDriverProfile, data).then((value) {
      getProfileResponse = getProfileResponseFromJson(value.toString());

      if (getProfileResponse.status == 200) {
        firstNameInputController.text =
            getProfileResponse.data?.firstname ?? "";
        lastNameInputController.text = getProfileResponse.data?.lastname ?? "";
        countryCodeController.text = getProfileResponse.data?.countrycode ?? "";
        numberInputController.text = getProfileResponse.data?.phone ?? "";
        emailInputController.text = getProfileResponse.data?.email ?? "";
        profileImage.value = getProfileResponse.data?.driverimagepath ?? "";
        profileApprovedByAdmin.value =
            getProfileResponse.data?.isapproved ?? false;
        loading.value = false;
      } else {
        CustomToast.show(getProfileResponse.message!);
        loading.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  setOnlineStatus() async {
    Map<String, Object> data = {};
    data[ApiParams.onduty] = onlineStatus.value;

    OnlineStatusResponse onlineStatusResponse;

    post(ApiEndPoints.setOnline, data).then((value) {
      onlineStatusResponse = onlineStatusResponseFromJson(value.toString());

      if (onlineStatusResponse.status == 200) {
        CustomToast.show(onlineStatusResponse.message!);

        if (onlineStatusResponse.data?.onduty == true) {
          locationSubscription?.cancel();
          Get.offAllNamed(Routes.ALL_ORDERS);
        } else {
          locationSubscription?.cancel();
          Get.offAllNamed(Routes.HOME);
        }
        print(
            'onlineStatusResponse.data?.onduty : ${onlineStatusResponse.data?.onduty}');
      } else {
        CustomToast.show(onlineStatusResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getOnlineStatus() async {
    if (await checkIsOnline() == true) {
      onlineStatus.value = true;
      headerTitle.value = 'allOrders'.tr;

      getBookings('New', 0);
    }
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

  void setPickupIcon() async {
    CurrentLocationMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/currentLocation.png');
  }

  void onMapCreated(GoogleMapController controller) {
    print("called");
    mapController = controller;
    mapCreated.value = true;
  }

  //Geting Current Location
  requestPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Get.offAllNamed(Routes.LOCATION_PERMISSION);
        return;
      }
    }

    print('_serviceEnabled __ $_serviceEnabled');

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("_permissionGranted== $_permissionGranted");
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Get.offAllNamed(Routes.LOCATION_PERMISSION);
        return;
      }
    }

    _locationData = await location.getLocation();

    // location.changeSettings(accuracy: LocationAccuracy.balanced, interval: 10000, distanceFilter: 5);

    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
      locationUpdateCounter++;
      print('================$locationUpdateCounter================');
      if ((locationUpdateCounter % 5 == 0) || (locationUpdateCounter == 1)) {
        updateGeoLocation(
            currentLocation.latitude!, currentLocation.longitude!);
      }

      currentLatitude.value = currentLocation.latitude!;
      currentLongitude.value = currentLocation.longitude!;
      if (mapCreated.value == true &&
          onlineStatus.value == false &&
          await checkIsOngoingBooking() == false) {
        print("---------------Inside Animate----------------");
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 14.0),
          ),
        );
      }

      print('currentLocationn ================ ${currentLocation.latitude}');
    });

    location.enableBackgroundMode(enable: true);

    //updateGeoLocation(19.479488, -155.602829);
  }

  updateFCMToken() async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    String fcm = '';
    fcm = fcmToken.toString();
    print('fcm token : $fcm');

    Map<String, Object> data = {};
    data[ApiParams.fcmtoken] = fcm;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.updateDriverFcmToken, data).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        // CustomToast.show(emptyResponse.message!);

        print('emptyResponse.message! : ${emptyResponse.message}');
      } else {
        CustomToast.show(emptyResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  updateGeoLocation(double lat, double lng) async {
    Map<String, Object> data = {};
    data[ApiParams.lat] = lat;
    data[ApiParams.lng] = lng;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.updateDriverGeoLocation, data).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        // CustomToast.show(emptyResponse.message!);

        print('emptyResponse.message! : ${emptyResponse.message}');
      } else {
        CustomToast.show(emptyResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void onLogout() {
    // await SessionManager().onLogout();
    // locationSubscription!.cancel();
    // mapController.dispose();
    // Get.offAllNamed(Routes.LOGIN);

    locationSubscription!.cancel().then((_) async {
      await SessionManager().onLogout();
      mapController.dispose();
      Get.offAllNamed(Routes.LOGIN);
    });
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
     print(onError
     );
    });

    return IsOngoingBooking;
  }

  void increment() => count.value++;
}
