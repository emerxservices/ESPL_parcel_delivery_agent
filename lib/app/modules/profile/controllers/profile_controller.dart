import 'dart:io';

import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/emptyResponse.dart';
import 'package:espl_parcel_driver/app/models/get_profile_response.dart';
import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:espl_parcel_driver/app/modules/login/models/forgot_password_response.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/services/actionSheet.dart';
import 'package:espl_parcel_driver/app/services/imagePicker.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends NetworkClient {
  HomeController homeController = Get.find();
  ActionSheet actionSheet = ActionSheet();
  ImagePickerServices imagePickerServices = Get.put(ImagePickerServices());
  RxString temporaryImage = ''.obs;
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController countryCodeController =
      TextEditingController(text: "+1");
  TextEditingController numberInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController =
      TextEditingController(text: "*************");
  String? otp;
  TextEditingController newPasswordInputController = TextEditingController();
  TextEditingController confirmNewPasswordInputController =
      TextEditingController();
  RxBool toggleTypeNewPassword = true.obs;
  RxBool toggleTypeConfirmNewPassword = true.obs;

  RxBool loadingData = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> backButtonPress() async {
    temporaryImage.value = '';
    Get.back();
    return false;
  }

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
      quality: 50,
    );
    temporaryImage.value = result!.path.toString();

    print(result.path);
  }

  void showPickFromBottomSheet(context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUploadButton(
                title: "Pick from gallery",
                onPress: () {
                  Get.back();
                  getImage(ImageSource.gallery);
                },
              ),
              ImageUploadButton(
                title: "Pick from camera",
                onPress: () {
                  Get.back();
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateProfileImage() async {
    if (temporaryImage.value != '') {
      loadingData.value = true;
      String? fileName = temporaryImage.value.split('/').last;

      var formData = dio.FormData.fromMap({
        'fileInput': await dio.MultipartFile.fromFile(temporaryImage.value,
            filename: fileName),
      });

      EmptyResponse emptyResponse;

      postFormData(ApiEndPoints.updateDriverProfile, formData).then((value) {
        emptyResponse = emptyResponseFromJson(value.toString());

        if (emptyResponse.status == 200) {
          loadingData.value = false;
          getProfileData();
          CustomToast.show(emptyResponse.message!);
        } else {
          CustomToast.show(emptyResponse.message!);
          loadingData.value = false;
        }
      }).catchError((onError) {
        print(onError);
        loadingData.value = false;
      });
    } else {
      CustomToast.show("Please select an image to continue.");
    }
  }

  getProfileData() async {
    loadingData.value = true;
    Map<String, Object> data = {};

    GetProfileResponse getProfileResponse;

    get(ApiEndPoints.getDriverProfile, data).then((value) {
      getProfileResponse = getProfileResponseFromJson(value.toString());

      if (getProfileResponse.status == 200) {
        homeController.profileImage.value =
            getProfileResponse.data?.driverimagepath ?? "";

        loadingData.value = false;
      } else {
        CustomToast.show(getProfileResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loadingData.value = false;
    });
  }

  handleChangePasswordSendOtp() async {
    Map<String, Object> data = {};
    data[ApiParams.email] = emailInputController.text.toString();

    ForgotPasswordResponse forgotPasswordResponse;
    loading.value = true;
    print(data);
    post(ApiEndPoints.driverForgotPwdSendOtp, data).then((value) async {
      forgotPasswordResponse = forgotPasswordResponseFromJson(value.toString());

      if (forgotPasswordResponse.status == 200) {
        loading.value = false;

        Get.toNamed(Routes.LOGGEDIN_VERIFY_CHANGE_PASSWORD);
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
        homeController.onLogout();
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

  deleteAccount() async {
    loadingData.value = true;
    Map<String, Object> data = {};

    EmptyResponse emptyResponse;

    post(ApiEndPoints.deleteDriverAccount, data).then((value) {
      emptyResponse = emptyResponseFromJson(value.toString());

      if (emptyResponse.status == 200) {
        homeController.onLogout();
        loadingData.value = false;
        CustomToast.show(emptyResponse.message!);
      } else {
        CustomToast.show(emptyResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
      loadingData.value = false;
    });
  }

  void increment() => count.value++;
}

class ImageUploadButton extends StatelessWidget {
  ImageUploadButton({required this.title, required this.onPress});

  String title;
  VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPress,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          title,
          style: kText18w700.copyWith(color: Colors.black54),
        ));
  }
}
