import 'package:espl_parcel_driver/app/components/customToast.dart';
import 'package:espl_parcel_driver/app/models/earning_response.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:espl_parcel_driver/services/api_endpoints.dart';
import 'package:espl_parcel_driver/services/api_param.dart';
import 'package:espl_parcel_driver/services/network_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyEarningsController extends NetworkClient {
  RxString selectedCategory = "Current week".obs;
  DateTime now = DateTime.now();
  Rx<DateTimeRange>? dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;
  final count = 0.obs;
  DateTime? currentWeekStartDate;
  DateTime? currentWeekEndDate;
  RxList<AllEarnings> currentWeekAllEarnings = <AllEarnings>[].obs;
  RxList<AllEarnings> historyAllEarnings = <AllEarnings>[].obs;

  RxString currentTotalCount = "0.0".obs;
  RxString historyTotalCount = "0.0".obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setCurrentData() {
    DateTime current_date = DateTime.now();
    DateTime startDateTime = DateTime(
        current_date.year, current_date.month, current_date.day - 6, current_date.hour, current_date.minute, current_date.second, current_date.millisecond);
    DateTime startDate = startDateTime;
    DateTime endDate = current_date;
    currentWeekStartDate = startDateTime;
    currentWeekEndDate = current_date;
    getData(startDate, endDate, 'current');
  }

  getData(DateTime startDate, DateTime endDate, String type) async {
    print("End Date");
    print(endDate);
    print(endDate.toUtc());
    historyAllEarnings.value = [];
    Map<String, Object> data = {};
    DateTime _startDate = startDate.toUtc().subtract(Duration(hours: 4));
    DateTime _endDate = endDate.toUtc().subtract(Duration(hours: 4));

    // data[ApiParams.startdate] =
    //     DateFormat('yyyy-MM-dd').format(startDate).toString();
    // data[ApiParams.enddate] =
    //     DateFormat('yyyy-MM-dd').format(endDate).toString();

    data[ApiParams.startdate] = DateFormat('yyyy-MM-dd HH:mm:ss').format(_startDate).toString();
    data[ApiParams.enddate] = DateFormat('yyyy-MM-dd HH:mm:ss').format(_endDate).toString();
    print("Printing Data $data");

    EarningResponse earningResponse;
    //post(ApiEndPoints.getDriverEarningsReport, data).then((value) {
    post(ApiEndPoints.getDriverEarningsReportNew, data).then((value) {
      earningResponse = earningResponseFromJson(value.toString());

      if (earningResponse.status == 200) {
        if (type == "current") {
          earningResponse.data?.allEarnings?.forEach((item) {
            print(item);
            currentWeekAllEarnings.add(item);
          });
          currentTotalCount.value = (earningResponse.data?.sum)!;
        } else {
          earningResponse.data?.allEarnings?.forEach((item) {
            historyAllEarnings.add(item);
          });
          historyTotalCount.value = (earningResponse.data?.sum)!;
        }
      } else {
        CustomToast.show(earningResponse.message!);
      }
    }).catchError((onError) {
      print(onError);
    });
    // print(
    //     'Start Date : ${DateFormat('yyyy-MM-dd').format(startDate).toString()}');
    // print('End Date : ${DateFormat('yyyy-MM-dd').format(endDate).toString()}');
    // print(type);
  }

  Future pickDateRange(context) async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      currentDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              secondary: bgBox,
              primary: orange,
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: orange, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDateRange == null) return;
    print(newDateRange);
    dateRange?.value = newDateRange;
    print(newDateRange.start);
    getData(newDateRange.start, newDateRange.end, 'history');
  }

  void increment() => count.value++;
}
