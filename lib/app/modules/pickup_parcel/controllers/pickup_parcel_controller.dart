import 'dart:convert';
import 'dart:io';

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
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class PickupParcelController extends NetworkClient {
  HomeController homeController = Get.find();

  dynamic bookingId = Get.arguments;
  RxInt radio1 = 1.obs;
  TextEditingController cancelOrderReason = TextEditingController();
  RxString cancelReason = "cancelReason1".tr.obs;
  late Rx<Map<dynamic, dynamic>> orderDetails = Rx({});
  var temporaryImage = ''.obs;

  static File? imagePath;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imagePermanent = File(image.path);
      compressImage(image.path);

      imagePath = imagePermanent;
    } catch (e) {
      print(e);
    }
    print('====================== $imagePath');
  }

  Future compressImage(imagePath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath + 'compressed.jpg',
      quality: 30,
    );
    temporaryImage.value = result!.path.toString();

    print(result.path);
  }

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

  RxBool loadingData = false.obs;

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

  handleUploadPickedParcelImage() async {
    if (temporaryImage.value != '') {
      loadingData.value = true;
      String? fileName = temporaryImage.value.split('/').last;

      var formData = dio.FormData.fromMap({
        'fileInput': await dio.MultipartFile.fromFile(temporaryImage.value,
            filename: fileName),
        'bookingid': bookingId,
      });

      EmptyResponse emptyResponse;

      postFormData(ApiEndPoints.driverPickupBooking, formData).then((value) {
        emptyResponse = emptyResponseFromJson(value.toString());

        if (emptyResponse.status == 200) {
          loadingData.value = false;
          CustomToast.show(emptyResponse.message!);
          Get.offNamed(Routes.REACHED_PICKUP_DESTINATION, arguments: bookingId);
        } else {
          CustomToast.show(emptyResponse.message!);
          loadingData.value = false;
        }
      }).catchError((onError) {
        print(onError);
        loading.value = false;
      });
    }
  }

  handelParcelDelivered() async {
    loadingData.value = true;
    Map<String, Object> data = {};
    data[ApiParams.bookingid] = bookingId;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.driverDeliveredBooking, data).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        homeController.locationSubscription?.cancel();
        Get.offAllNamed(Routes.ALL_ORDERS);
        CustomToast.show(emptyResponse.message!);
        loadingData.value = false;
      } else {
        CustomToast.show(emptyResponse.message!);
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

                      if (cancelReason.value == 'Others') {
                        if (cancelOrderReason.text.isNotEmpty) {
                          handleCancelOrder();
                        }
                      } else {
                        handleCancelOrder();
                      }
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

  void increment() => count.value++;
}
