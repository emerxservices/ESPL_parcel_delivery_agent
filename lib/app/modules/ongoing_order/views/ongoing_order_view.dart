import 'package:espl_parcel_driver/app/modules/home/views/sidemenu_view.dart';
import 'package:espl_parcel_driver/app/routes/app_pages.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/ongoing_order_controller.dart';

class OngoingOrderView extends GetView<OngoingOrderController> {
  OngoingOrderView({Key? key}) : super(key: key);

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange,
      appBar: Appbar(),
      drawer: Sidemenu(controller: homeController),
      body: Obx(() => controller.loadingData.value == true
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
                    return OngoingRideCard(
                      data: controller.bookings,
                      index: index,
                      controller: controller,
                    );
                  },
                )
              : Center(
                  child: Text(
                    'noOrdersFound'.tr,
                    style: kText18w700.copyWith(color: Colors.white),
                  ),
                )),
    );
  }
}

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: orange,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: orange,
      title: Text(
        'ongoingOrders'.tr,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: "Montserrat",
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}

class OngoingRideCard extends StatelessWidget {
  OngoingRideCard({
    super.key,
    required this.data,
    required this.index,
    required this.controller,
  });

  dynamic data;
  int index;
  final OngoingOrderController controller;

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
                Text(
                  '${'orderId'.tr} ${data.value[index].bookingno}',
                  style: kText14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
