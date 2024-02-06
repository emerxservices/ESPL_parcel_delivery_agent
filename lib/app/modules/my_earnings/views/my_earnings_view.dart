import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/modules/my_earnings/controllers/my_earnings_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyEarningsView extends GetView<MyEarningsController> {
  const MyEarningsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    dynamic screenWidth = MediaQuery.of(context).size.width - 40;

    dynamic earnings = [
      {
        "orderId": "#123",
        "dropoffDate": "2023-02-16T13:13:21.504Z",
        "amount": "\$ 10.2"
      },
      {
        "orderId": "#456",
        "dropoffDate": "2023-05-18T16:06:45.255Z",
        "amount": "\$ 102.2"
      },
      {
        "orderId": "#789",
        "dropoffDate": "2011-10-05T14:48:00.000Z",
        "amount": "\$ 104.2"
      },
    ];
    return Scaffold(
      appBar: CustomMultiAppbar(
        title: 'myEarnings'.tr,
        
        onLeadingIconButtonPress: () {
          Get.back();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            // decoration:
            //     BoxDecoration(border: Border.all(width: 1, color: orange)),
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greyShade2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: controller.selectedCategory == 'currentWeek'.tr
                            ? orange
                            : Colors.white,
                        child: InkWell(
                          splashColor: whiteOpacity25,
                          highlightColor: Colors.transparent,
                          // splashColor: Colors.grey[200],
                          onTap: () {
                            controller.selectedCategory.value =
                                'currentWeek'.tr;
                          },
                          child: Container(
                            height: 53,
                            child: Center(
                              child: Text('currentWeek'.tr,
                                  style: kText18w700.copyWith(
                                      color: controller.selectedCategory ==
                                              'currentWeek'.tr
                                          ? Colors.white
                                          : black)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: controller.selectedCategory == 'history'.tr
                            ? orange
                            : Colors.white,
                        child: InkWell(
                          splashColor: whiteOpacity25,
                          highlightColor: Colors.transparent,
                          // splashColor: Colors.grey[200],
                          onTap: () {
                            controller.selectedCategory.value = 'history'.tr;

                            controller.dateRange?.value = DateTimeRange(
                                start: DateTime.now(), end: DateTime.now());
                            controller.getData(
                                DateTime.now(), DateTime.now(), "history");
                          },
                          child: Container(
                            height: 53,
                            child: Center(
                              child: Text(
                                'history'.tr,
                                style: kText18w700.copyWith(
                                    color: controller.selectedCategory ==
                                            'history'.tr
                                        ? Colors.white
                                        : black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Obx(() => controller.selectedCategory == 'currentWeek'.tr
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: bgBox,
                            borderRadius: BorderRadius.circular(10.0)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: black,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // controller.dateRange?.value != null?
                                    Text(
                                      '${DateFormat('MMM d').format(controller.currentWeekStartDate!)} - ${DateFormat('MMM d').format(controller.currentWeekEndDate!)}',
                                      style: kText18w700.copyWith(color: black),
                                    )
                                    // : Text(
                                    //     '${DateFormat('MMM d').format(DateTime.now())} - ${DateFormat('MMM d').format(DateTime.now())}',
                                    //     style: kText18w700.copyWith(
                                    //         color: darkBluePrimary),
                                    //   )
                                  ],
                                ),
                                // Material(
                                //   color: Colors.transparent,
                                //   child: InkWell(
                                //     splashColor: orangeOverlayPrimary,
                                //     borderRadius: BorderRadius.circular(15),
                                //     onTap: () {
                                //       controller.pickDateRange(context);
                                //     },
                                //     child: const Icon(
                                //       Icons.keyboard_arrow_down_rounded,
                                //       size: 30,
                                //       color: darkBlue,
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(
                                    "\$ ${controller.currentTotalCount.value}",
                                    style: kText18w700.copyWith(color: black))),
                                Text(
                                  'paid'.tr,
                                  style:
                                      kText18w700.copyWith(color: greenPrimary),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'breakdown'.tr,
                          style: kText18w700,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: greyShade2))),
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * .38,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'bookingDate'.tr,
                                style: kText14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                            Container(
                              width: screenWidth * .37,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'earnings'.tr,
                                style: kText14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                            Container(
                              width: screenWidth * .25,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'orderNo'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kText14w600,
                              )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                            itemCount: controller.currentWeekAllEarnings.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: greyShade2))),
                                child: Row(
                                  children: [
                                    Container(
                                        width: screenWidth * .38,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Center(
                                          child: Text(
                                            DateFormat('dd-MM-y').format(
                                                DateTime.parse(controller
                                                        .currentWeekAllEarnings
                                                        .value[index]
                                                        .bookingdate!)
                                                    .toLocal()),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kText16w400.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Container(
                                      width: screenWidth * .30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          controller.currentWeekAllEarnings
                                              .value[index].earnings!
                                              .toStringAsFixed(2),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kText16w400.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * .30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          '${controller.currentWeekAllEarnings.value[index].bookingno!.toString()}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: kText16w400.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: bgBox,
                            borderRadius: BorderRadius.circular(10.0)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: black,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    controller.dateRange?.value != null
                                        ? Text(
                                            '${DateFormat('MMM d').format(controller.dateRange!.value.start)} - ${DateFormat('MMM d').format(controller.dateRange!.value.end)}',
                                            style: kText18w700.copyWith(
                                                color: black),
                                          )
                                        : Text(
                                            '${DateFormat('MMM d').format(DateTime.now())} - ${DateFormat('MMM d').format(DateTime.now())}',
                                            style: kText18w700.copyWith(
                                                color: darkBluePrimary),
                                          )
                                  ],
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: orangeOverlayPrimary,
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      controller.pickDateRange(context);
                                    },
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 30,
                                      color: black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("\$ ${controller.historyTotalCount.value}",
                                    style: kText18w700.copyWith(color: black)),
                                Text(
                                  'paid'.tr,
                                  style:
                                      kText18w700.copyWith(color: greenPrimary),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'breakdown'.tr,
                          style: kText18w700,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: greyShade2))),
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * .38,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'bookingDate'.tr,
                                style: kText14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                            Container(
                              width: screenWidth * .37,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'noOfBookings'.tr,
                                style: kText14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ),
                            Container(
                              width: screenWidth * .25,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Center(
                                  child: Text(
                                'earnings'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kText14w600,
                              )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                            itemCount: controller.historyAllEarnings.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: greyShade2))),
                                child: Row(
                                  children: [
                                    Container(
                                        width: screenWidth * .38,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Center(
                                          child: Text(
                                            //DateFormat('dd-MM-y').format(DateTime.parse(controller.historyAllEarnings.value[index].bookingdate!).toLocal()),
                                            DateFormat('MMM d, yyyy h:mm a')
                                                .format(DateTime.parse(controller
                                                            .historyAllEarnings
                                                            .value[index]
                                                            .bookingdate! ??
                                                        "")
                                                    .toLocal()),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kText16w400.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        )),
                                    Container(
                                      width: screenWidth * .37,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          controller.historyAllEarnings
                                              .value[index].earnings!
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kText16w400.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * .25,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          '\$ ${controller.historyAllEarnings.value[index].earnings!.toString()}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: kText16w400.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
