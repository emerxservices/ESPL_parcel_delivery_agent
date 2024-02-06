import 'dart:async';
import 'dart:convert';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/emptyResponse.dart';
import 'package:espl_parcel_driver/app/models/get_profile_response.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/services/actionSheet.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class ProfileSetupController extends NetworkClient {
  // TextEditingController vehicleNameInputController = TextEditingController();
  TextEditingController vehicleRegNumberInputController =
      TextEditingController();
  TextEditingController vehicleTypeNameInputController =
      TextEditingController();

  RxString drivingLicenseImage = ''.obs;

  TextEditingController drivingLicenseNumberInputController =
      TextEditingController();
  TextEditingController licenseExpiryDateInputController =
      TextEditingController();
  RxString licenseExpiryDate = "".obs;
  RxString profileImage = ''.obs;
  var temporaryImage = ''.obs;
  final count = 0.obs;
  ActionSheet actionSheet = ActionSheet();

  RxBool loading = false.obs;
  late Rx<Map<dynamic, dynamic>> profileData = Rx({});
  RxString selectedCarType = ''.obs;
  RxInt vehicleTypeId = 0.obs;

  List? carTypes = [];
  RxBool acceptedTermsAndConditions = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<bool> backButtonPressOfVehicleRegistration() async {
    Get.back();
    return false;
  }

  Future<bool> backButtonPress() async {
    Get.back();
    return false;
  }

  void goToCongratulations() => Get.toNamed(Routes.CONGRATULATIONS);

  void goToHome() => Get.offAllNamed(Routes.HOME);

  //Get profile Data
  getProfileData() async {
    loading.value = true;
    Map<String, Object> data = {};

    GetProfileResponse getProfileResponse;

    get(ApiEndPoints.getDriverProfile, data).then((value) {
      getProfileResponse = getProfileResponseFromJson(value.toString());

      if (getProfileResponse.status == 200) {
        vehicleRegNumberInputController.text =
            getProfileResponse.data?.vehicleno ?? "";
        drivingLicenseImage.value =
            getProfileResponse.data?.licenceimagepath ?? "";
        drivingLicenseNumberInputController.text =
            getProfileResponse.data?.licenseno ?? "";
        licenseExpiryDateInputController.text =
            getProfileResponse.data?.licenseexpirydate ?? "";
        licenseExpiryDate.value =
            getProfileResponse.data?.licenseexpirydate ?? "";
        var strJsonData = jsonEncode(value.data);
        profileData.value =
            Map<dynamic, dynamic>.from(json.decode(strJsonData));
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

  handleVehicleRegistration() async {
    loading.value = true;
    Map<String, Object> data = {};
    data[ApiParams.vehicleno] = vehicleRegNumberInputController.text;

    EmptyResponse emptyResponse;

    post(ApiEndPoints.setDriverVehicle, data)
        .then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        loading.value = false;
        CustomToast.show(emptyResponse.message!);
        Get.back(result: "updated");
      } else {
        CustomToast.show(emptyResponse.message!);
        loading.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }

  handleDrivingLicenseDetails() async {
    loading.value = true;
    String? fileName = temporaryImage.value.split('/').last;

    var formData = temporaryImage.value != ""
        ? dio.FormData.fromMap({
            'fileInput': await dio.MultipartFile.fromFile(temporaryImage.value,
                filename: fileName),
            'licenseno': drivingLicenseNumberInputController.text,
            'licenseexpirydate': licenseExpiryDateInputController.text,
          })
        : dio.FormData.fromMap({
            'licenseno': drivingLicenseNumberInputController.text,
            'licenseexpirydate': licenseExpiryDateInputController.text,
          });
    EmptyResponse emptyResponse;
    postFormData(ApiEndPoints.setDriverLicense, formData)
        .then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        loading.value = false;
        CustomToast.show(emptyResponse.message!);
        Get.back(result: "updated");
      } else {
        CustomToast.show(emptyResponse.message!);
        loading.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loading.value = false;
    });
  }
}
