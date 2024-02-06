import 'dart:async';
import 'dart:convert';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/booking_response.dart';
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
import 'package:url_launcher/url_launcher.dart';

class BookingConfirmationController extends NetworkClient {
  dynamic bookingId = Get.arguments;
  HomeController homeController = Get.find();
  late Rx<Map<dynamic, dynamic>> orderDetails = Rx({});

  // late GoogleMapController mapController;
  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String tripStatus = "";
  RxBool isMapControllerInitialised = false.obs;
  RxBool polylinesAvailable = false.obs;

  BitmapDescriptor? pickupMarkerIcon;
  BitmapDescriptor? dropMarkerIcon;

  late LatLng pickupLocation = LatLng(orderDetails.value['data']['pickuplat'],
      orderDetails.value['data']['pickuplng']);
  late LatLng dropLocation = LatLng(orderDetails.value['data']['droplat'],
      orderDetails.value['data']['droplng']);

  RxBool loadingData = false.obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    //Marker Icon
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
    // mapController.dispose();
  }

  void setPickupIcon() async {
    pickupMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/pickupIcon.png');
  }

  void setDropIcon() async {
    dropMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'images/dropIcon.png');
  }

  void onMapCreated(GoogleMapController controller) {
    print("Called");
    // mapController = controller;
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }

    isMapControllerInitialised.value = true;

    _getPolyline();

    Timer(Duration(seconds: 1), () {
      try {
        controller.animateCamera(
          CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                    (orderDetails.value['data']['pickuplat'] <=
                            orderDetails.value['data']['droplat']
                        ? orderDetails.value['data']['pickuplat']
                        : orderDetails.value['data']['droplat']),
                    (orderDetails.value['data']['pickuplng'] <=
                            orderDetails.value['data']['droplng']
                        ? orderDetails.value['data']['pickuplng']
                        : orderDetails.value['data']['droplng'])),
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
        );
      } catch (e) {
        print(e);
      }
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
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApiKey,
        PointLatLng(orderDetails.value['data']['pickuplat'],
            orderDetails.value['data']['pickuplng']),
        PointLatLng(orderDetails.value['data']['droplat'],
            orderDetails.value['data']['droplng']),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        polylinesAvailable.value = true;
      });
    }
    addPolyLine();
  }

  void handleRouteToGoogleMap() {
    var url = '';

    if (orderDetails.value['data']['pickuplat'] != null &&
        orderDetails.value['data']['pickuplng'] != null &&
        orderDetails.value['data']['droplat'] != null &&
        orderDetails.value['data']['droplng'] != null) {
      url =
          'https://www.google.com/maps/dir/?api=1&origin=${orderDetails.value['data']['pickuplat']},${orderDetails.value['data']['pickuplng']}&destination=${orderDetails.value['data']['droplat']},${orderDetails.value['data']['droplng']}&travelmode=driving&dir_action=navigate';
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
      } else {
        CustomToast.show(orderDetailsResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loadingData.value = false;
    });
  }

  handleRejectBooking() async {
    Map<String, Object> data = {};
    data[ApiParams.bookingid] = bookingId;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverRejectBooking, data).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        CustomToast.show(emptyResponse.message!);
        Get.back(result: "rejected");
      } else {
        CustomToast.show(emptyResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  handleAcceptBooking() async {
    Map<String, Object> body = {};
    body[ApiParams.bookingid] = bookingId;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverAcceptBooking, body).then((value) async {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        getOrderDetails().then((value) {
          CustomToast.show(emptyResponse.message!);

          homeController.locationSubscription
              ?.cancel()
              .then((value) => Get.offAllNamed(Routes.ONGOING_ORDER));

          print('Value of Order');
        });
        print('onlineStatusResponse.data?.onduty : ${emptyResponse.message}');
      } else {
        CustomToast.show(emptyResponse.message!);

        Get.back(result: "alreadyAccepted");
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  onContinueButtonPress() async {
    // homeController.locationSubscription?.cancel();
    // await homeController.requestPermission();
    print("SUCCESSSSSSS");
    if (orderDetails.value['data']['bookingstatus'] == "DRIVER ACCEPTED" ||
        orderDetails.value['data']['bookingstatus'] == "PICKUP") {
      Get.offNamed(Routes.REACHED_PICKUP_DESTINATION, arguments: bookingId);
    } else if (orderDetails.value['data']['bookingstatus'] ==
            "REACHED PICKUP LOCATION" ||
        orderDetails.value['data']['bookingstatus'] ==
            "REACHED DROP LOCATION") {
      Get.offNamed(Routes.PICKUP_PARCEL, arguments: bookingId);
    }
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

  void increment() => count.value++;
}
