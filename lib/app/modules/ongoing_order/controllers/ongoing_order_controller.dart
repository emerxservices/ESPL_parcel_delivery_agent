import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/booking_response.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingOrderController extends NetworkClient {
  final count = 0.obs;
  RxList<Bookings> bookings = <Bookings>[].obs;
  RxBool loading = false.obs;
  final scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;
  RxInt skip = 0.obs;
  RxBool loadingData = false.obs;
  RxBool isFirstTimeLodingData = true.obs;
  RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getBookings("Active", 0);
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
      getBookings('Active', skip.value);

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
    getBookings("Active", skip.value);
  }

  void increment() => count.value++;
}
