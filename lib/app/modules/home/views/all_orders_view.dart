import 'package:espl_parcel_driver/app/components/customAppbar.dart';
import 'package:espl_parcel_driver/app/modules/home/controllers/home_controller.dart';
import 'package:espl_parcel_driver/app/modules/home/views/sidemenu_view.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllOrdersView extends GetView<HomeController> {
  AllOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.loadingData.value);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'allOrders'.tr,
        onlineStatus: controller.onlineStatus,
        onSwitchPress: (val) {
          controller.onlineStatus.value = val;
          controller.setOnlineStatus();
        },
        onLeadingIconPress: () {},
      ),
      drawer: Sidemenu(controller: controller),
      body: Obx(() => controller.loadingData.value == true
          ? const Center(
              child: CircularProgressIndicator(
                color: orangePrimary,
              ),
            )
          : controller.profileApprovedByAdmin.value == false
              ? IntrinsicHeight(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 15.0, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: orange,
                      ),
                      child: Center(
                        child: Text(
                          "profileUnderReview".tr,
                          style: kText16w700.copyWith(
                              color: Colors.white, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : controller.bookings.length > 0
                  ? ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.bookings.length,
                      itemBuilder: (context, index) {
                        return NewRideCard(
                          data: controller.bookings,
                          index: index,
                          controller: controller,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'noOrdersFound'.tr,
                        style: kText18w700,
                      ),
                    )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: orangePrimary,
        onPressed: () {
          controller.resetBooking();
        },
        child: const Icon(
          Icons.refresh_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class NewRideCard extends StatelessWidget {
  NewRideCard({
    super.key,
    required this.data,
    required this.index,
    required this.controller,
  });

  dynamic data;
  int index;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14, left: 10, right: 10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: lightOrange,
          highlightColor: Colors.transparent,
          // splashColor: Colors.grey[200],
          onTap: () async {
            // Call this method from bottom new button also
            var result = await Get.toNamed(Routes.BOOKING_CONFIRMATION,
                arguments: data.value[index].bookingid);
            if (result == 'rejected' || result == 'alreadyAccepted') {
              controller.resetBooking();
            }
          },
          child: Container(
            margin: EdgeInsets.all(20),
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "new".tr,
                        style: kText14w600.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 14,
                ),

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
                        height: 42,
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

                // const SizedBox(
                //   height: 14,
                // ),
                //
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size.fromHeight(45),
                //     backgroundColor: orange,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10), // <-- Radius
                //     ),
                //   ),
                //   onPressed: () async {
                //     // Call this method from bottom new button also
                //     var result = await Get.toNamed(Routes.BOOKING_CONFIRMATION,
                //         arguments: data.value[index].bookingid);
                //     if (result == 'rejected' || result == 'alreadyAccepted') {
                //       controller.resetBooking();
                //     }
                //   },
                //   child: Text(
                //     "new".tr,
                //     style: kText14w600,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
