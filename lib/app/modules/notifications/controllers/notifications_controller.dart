import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/notification_response.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends NetworkClient {
  RxList<Notifications> notifications = <Notifications>[].obs;
  RxBool loading = false.obs;
  final scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;
  RxInt skip = 0.obs;
  RxBool loadingData = false.obs;
  RxBool isFirstTimeLoadingData = true.obs;
  RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications(0);
    scrollController.addListener(_scrollListener);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _scrollListener() {
    if (isLoadingMore.value) return;
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        skip.value <= totalCount.value) {
      isLoadingMore.value = true;

      skip.value = skip.value + 3;
      getNotifications(skip.value);

      isLoadingMore.value = false;
    }
  }

  getNotifications(int skip) async {
    if (isFirstTimeLoadingData.value == true) {
      loadingData.value = true;
      isFirstTimeLoadingData.value = false;
    }
    Map<String, Object> data = {};
    data[ApiParams.skip] = skip;
    data[ApiParams.limit] = 15;

    NotificationResponse notificationResponse;

    post(ApiEndPoints.getDriverNotifications, data).then((value) {
      notificationResponse = notificationResponseFromJson(value.toString());

      if (notificationResponse.status == 200) {
        notificationResponse.data?.notifications?.forEach((item) {
          notifications.add(item);
        });
        totalCount.value = (notificationResponse.data?.totalcount)!;
        loadingData.value = false;
      } else {
        CustomToast.show(notificationResponse.message!);
        loadingData.value = false;
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
