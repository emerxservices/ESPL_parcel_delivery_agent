import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyShade3,
      appBar: CustomMultiAppbar(
        title: 'myOrders'.tr,
        // appBarBackgroundColor: greyShade3,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "history".tr,
            style: kText18w600.copyWith(color: orange),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 1,
                color: inActiveGrey,
              )),
              Expanded(
                  child: Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: orange,
                ),
              )),
              Expanded(
                  child: Container(
                height: 1,
                color: inActiveGrey,
              )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
              () => controller.loadingData.value == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: orangePrimary,
                      ),
                    )
                  : controller.bookings.length > 0
                      ? ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.bookings.length,
                          itemBuilder: (context, index) {
                            return PastRideCard(
                              data: controller.bookings,
                              index: index,
                              controller: controller,
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'noOrdersFound'.tr,
                            style: kText18w700.copyWith(color: orangePrimary),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class Seperator20 extends StatelessWidget {
  const Seperator20({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class PastRideCard extends StatelessWidget {
  PastRideCard({
    super.key,
    required this.data,
    required this.index,
    required this.controller,
  });

  dynamic data;
  int index;
  final MyOrdersController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14, left: 14, right: 14),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        child: InkWell(
          splashColor: lightOrange,
          highlightColor: Colors.transparent,
          // splashColor: Colors.grey[200],
          onTap: () {
            Get.toNamed(Routes.ORDER_DETAILS,
                arguments: data.value[index].bookingid);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'orderId'.tr} ${data.value[index].bookingno}',
                        style: kText14w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      data.value[index].bookingstatusid == 7
                          ? "cancelled".tr
                          : "completed".tr,
                      style: kText18w600.copyWith(
                        color: data.value[index].bookingstatusid == 7
                            ? orange
                            : greenPrimary,
                      ),
                    )
                  ],
                ),

                Seperator20(),

                //Location UI
                IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 70,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 18.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: greyShade3,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        child: Text(
                                          (DateFormat('MMM d, yyyy h:mm a')
                                                  .format(DateTime.parse(data
                                                          .value[index]
                                                          .createdondate)
                                                      .toLocal()))
                                              .toString(),
                                          style: kText12w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          data.value[index].pickupaddress,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: kText14w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: 46,
                            left: 11.5,
                            child: Container(
                              height: 50.0,
                              child: Image.asset('images/dottedLine.png'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 18.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.value[index].dropaddress,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kText14w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
