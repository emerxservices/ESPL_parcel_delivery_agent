import 'dart:async';
import 'dart:convert';

import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/models/emptyResponse.dart';
import 'package:espl_parcel_driver/app/models/order_details.dart';
import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class ReachedPickupDestinationController extends NetworkClient {
  HomeController homeController = Get.find();

  dynamic bookingId = Get.arguments;
  late Rx<Map<dynamic, dynamic>> orderDetails = Rx({});

  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String tripStatus = "";
  RxBool isMapControllerInitialised = false.obs;
  RxBool polylinesAvailable = false.obs;
  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;

  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? dropMarkerIcon;

  RxInt radio1 = 1.obs;
  TextEditingController cancelOrderReason = TextEditingController();
  RxString cancelReason = "cancelReason1".tr.obs;

  late LatLng pickupLocation = LatLng(orderDetails.value['data']['pickuplat'],
      orderDetails.value['data']['pickuplng']);
  late LatLng dropLocation = LatLng(orderDetails.value['data']['droplat'],
      orderDetails.value['data']['droplng']);
  final count = 0.obs;

  RxBool loadingData = false.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
    setPickupIcon();
    setDropIcon();
    getOrderDetails();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    mapController = Completer();
    super.onClose();
  }

  void setPickupIcon() async {
    pickupMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/pickupIcon.png');
  }

  void setDropIcon() async {
    dropMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/dropIcon.png');
  }

  //Geting Current Location
  _requestPermission() async {
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

    print('_serviceEnabled __ $_serviceEnabled');

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print("_permissionGranted== $_permissionGranted");
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    if (_locationData != null) {
      currentLatitude.value = _locationData.latitude!;
      currentLongitude.value = _locationData.longitude!;
      animateMap();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    print("Called");
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    isMapControllerInitialised.value = true;
  }

  animateMap() {
    Timer(Duration(seconds: 3), () {
      mapController.future.then((value) => value.animateCamera(
            orderDetails.value['data']?['bookingstatus'] == "DRIVER ACCEPTED"
                ? CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(
                          currentLatitude.value <=
                                  orderDetails.value['data']['pickuplat']
                              ? currentLatitude.value
                              : orderDetails.value['data']['pickuplat'],
                          currentLongitude.value <=
                                  orderDetails.value['data']['pickuplng']
                              ? currentLongitude.value
                              : orderDetails.value['data']['pickuplng']),
                      northeast: LatLng(
                        currentLatitude.value <=
                                orderDetails.value['data']['pickuplat']
                            ? orderDetails.value['data']['pickuplat']
                            : currentLatitude.value,
                        currentLongitude.value <=
                                orderDetails.value['data']['pickuplng']
                            ? orderDetails.value['data']['pickuplng']
                            : currentLongitude.value,
                      ),
                    ),
                    60)
                : CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(
                          orderDetails.value['data']['pickuplat'] <=
                                  orderDetails.value['data']['droplat']
                              ? orderDetails.value['data']['pickuplat']
                              : orderDetails.value['data']['droplat'],
                          orderDetails.value['data']['pickuplng'] <=
                                  orderDetails.value['data']['droplng']
                              ? orderDetails.value['data']['pickuplng']
                              : orderDetails.value['data']['droplng']),
                      northeast: LatLng(
                        orderDetails.value['data']['pickuplat'] <=
                                orderDetails.value['data']['droplat']
                            ? orderDetails.value['data']['droplat']
                            : orderDetails.value['data']['pickuplat'],
                        orderDetails.value['data']['pickuplng'] <=
                                orderDetails.value['data']['droplng']
                            ? orderDetails.value['data']['droplng']
                            : orderDetails.value['data']['pickuplng'],
                      ),
                    ),
                    60),
          ));
      _getPolyline();
    });
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 3,
      patterns: [
        PatternItem.dash(10),
        PatternItem.gap(10),
      ],
    );
    polylines[id] = polyline;
    print("Here");
  }

  _getPolyline() async {
    print("Called 123");
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleMapApiKey,
          orderDetails.value['data']['bookingstatus'] == "DRIVER ACCEPTED"
              ? PointLatLng(currentLatitude.value, currentLongitude.value)
              : PointLatLng(orderDetails.value['data']['pickuplat'],
                  orderDetails.value['data']['pickuplng']),
          orderDetails.value['data']['bookingstatus'] == "DRIVER ACCEPTED"
              ? PointLatLng(orderDetails.value['data']['pickuplat'],
                  orderDetails.value['data']['pickuplng'])
              : PointLatLng(orderDetails.value['data']['droplat'],
                  orderDetails.value['data']['droplng']),
          travelMode: TravelMode.driving);
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          polylinesAvailable.value = true;
        });
      }
      addPolyLine();
    } catch (e) {
      print(e);
    }
  }

  void handleRouteToGoogleMap() {
    var url = '';

    if (orderDetails.value['data']['pickuplat'] != null &&
        orderDetails.value['data']['pickuplng'] != null &&
        orderDetails.value['data']['droplat'] != null &&
        orderDetails.value['data']['droplng'] != null &&
        currentLatitude.value != null &&
        currentLongitude.value != null) {
      if (orderDetails.value['data']['bookingstatus'] == "DRIVER ACCEPTED") {
        url =
            'https://www.google.com/maps/dir/?api=1&origin=${currentLatitude.value},${currentLongitude.value}&destination=${orderDetails.value['data']['pickuplat']},${orderDetails.value['data']['pickuplng']}&travelmode=driving&dir_action=navigate';
      } else {
        url =
            'https://www.google.com/maps/dir/?api=1&origin=${orderDetails.value['data']['pickuplat']},${orderDetails.value['data']['pickuplng']}&destination=${orderDetails.value['data']['droplat']},${orderDetails.value['data']['droplng']}&travelmode=driving&dir_action=navigate';
      }
    }

    print(url);
    if (url != "") {
      _launchURL(url);
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print("Couldn't launch google map ");
    }
  }

  getOrderDetails() async {
    loadingData.value = true;
    Map<String, Object> data = {};
    data[ApiParams.bookingid] = bookingId;

    OrderDetailsResponse orderDetailsResponse;

    post(ApiEndPoints.driverBookingDetails, data).then((value) {
      orderDetailsResponse = orderDetailsResponseFromJson(value.toString());

      if (orderDetailsResponse.status == 200) {
        var strJsonData = jsonEncode(value.data);
        orderDetails.value =
            Map<dynamic, dynamic>.from(json.decode(strJsonData));
        loadingData.value = false;
        animateMap();
      } else {
        CustomToast.show(orderDetailsResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loadingData.value = false;
    });
  }

  void showCancelBottomSheet(context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 5,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: inActiveGrey,
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'cancelYourOrder'.tr,
                      style: kText22w600,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: inActiveGrey,
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  "chooseReason".tr,
                  style: kText16w700,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Obx(
                      () => Radio(
                        activeColor: Colors.blue,
                        value: 1,
                        groupValue: radio1.value,
                        onChanged: (value) {
                          radio1.value = 1; //selected value
                          cancelReason.value = "cancelReason1".tr;
                          resetCancelReason();
                        },
                      ),
                    ),
                    Text(
                      "cancelReason1".tr,
                      style: kText14w400,
                    )
                  ],
                ),
                Row(
                  children: [
                    Obx(
                      () => Radio(
                        activeColor: Colors.blue,
                        value: 2,
                        groupValue: radio1.value,
                        onChanged: (value) {
                          radio1.value = 2;
                          cancelReason.value = "cancelReason2".tr;
                          resetCancelReason();
                        },
                      ),
                    ),
                    Text(
                      "cancelReason2".tr,
                      style: kText14w400,
                    )
                  ],
                ),
                Row(
                  children: [
                    Obx(
                      () => Radio(
                        activeColor: Colors.blue,
                        value: 3,
                        groupValue: radio1.value,
                        onChanged: (value) {
                          radio1.value = 3;
                          cancelReason.value = "cancelReason3".tr;
                        },
                      ),
                    ),
                    Text(
                      "cancelReason3".tr,
                      style: kText14w400,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => cancelReason.value == "Others"
                    ? TextInputBox(
                        controller: cancelOrderReason,
                        placeHolder: 'cancelOrderPlaceholder'.tr,
                        onValueChange: (value) {
                          print(value);
                        },
                      )
                    : Container()),
                const SizedBox(
                  height: 20,
                ),
                ButtonPrimary(
                    onPress: () {
                      Get.back();
                      Timer(Duration(seconds: 1), () {
                        if (cancelReason.value == 'Others') {
                          if (cancelOrderReason.text.isNotEmpty) {
                            handleCancelOrder();
                          }
                        } else {
                          handleCancelOrder();
                        }
                      });
                    },
                    title: "submit".tr),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetCancelReason() {
    cancelOrderReason.text = "";
  }

  handleCancelOrder() async {
    loadingData.value = true;
    Map<String, Object> body = {};
    body[ApiParams.bookingid] = bookingId;
    body[ApiParams.reason] = cancelReason.value == "Others"
        ? cancelOrderReason.text
        : cancelReason.value;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverCancelledBooking, body).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        loadingData.value = false;
        homeController.locationSubscription?.cancel();
        Get.offAllNamed(Routes.ALL_ORDERS);
        CustomToast.show(emptyResponse.message!);
        print('driverReachedPickupLocation : ${emptyResponse.message}');
      } else {
        loadingData.value = false;
        CustomToast.show(emptyResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  handleReachedPickupLocation() async {
    Map<String, Object> body = {};
    body[ApiParams.bookingid] = bookingId;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverReachedPickupLocation, body).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        getOrderDetails().then((value) {
          Get.offNamed(Routes.PICKUP_PARCEL, arguments: bookingId);
        });
        print('driverReachedPickupLocation : ${emptyResponse.message}');
      } else {
        CustomToast.show(emptyResponse.message!);
        Get.back(result: "alreadyAccepted");
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  handleReachedDropLocation() async {
    Map<String, Object> body = {};
    body[ApiParams.bookingid] = bookingId;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverReachedDropLocation, body).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        getOrderDetails().then((value) {
          Get.offNamed(Routes.PICKUP_PARCEL, arguments: bookingId);
        });
        print('driverReachedPickupLocation : ${emptyResponse.message}');
      } else {
        CustomToast.show(emptyResponse.message!);
        Get.back(result: "alreadyAccepted");
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void increment() => count.value++;
}
