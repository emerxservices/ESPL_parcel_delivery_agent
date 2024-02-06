import 'dart:convert';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/order_details.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:get/get.dart';

class OrderDetailsController extends NetworkClient {
  dynamic bookingId = Get.arguments;
  late Rx<Map<dynamic, dynamic>> orderDetails = Rx({});
  RxBool loadingData = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getOrderDetails();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  void increment() => count.value++;
}
