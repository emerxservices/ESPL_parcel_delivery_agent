import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/textButton.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/reached_pickup_destination_controller.dart';

class ReachedPickupDestinationView
    extends GetView<ReachedPickupDestinationController> {
  const ReachedPickupDestinationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.loadingData.value == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: orangePrimary,
                ),
              )
            : Column(
                children: [
                  //Google map
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      children: [
                        Obx(() => GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      controller.currentLatitude.value,
                                      controller.currentLongitude.value),
                                  zoom: 11.0),
                              zoomControlsEnabled: false,
                              onMapCreated: controller.onMapCreated,
                              markers: controller
                                          .isMapControllerInitialised.value ==
                                      true
                                  ? {
                                      Marker(
                                        markerId: const MarkerId('pickup'),
                                        position: controller.orderDetails
                                                        .value['data']
                                                    ['bookingstatus'] ==
                                                'DRIVER ACCEPTED'
                                            ? LatLng(
                                                controller
                                                    .currentLatitude.value,
                                                controller
                                                    .currentLongitude.value)
                                            : LatLng(
                                                controller.orderDetails
                                                    .value['data']['pickuplat'],
                                                controller.orderDetails
                                                        .value['data']
                                                    ['pickuplng']),
                                        icon: controller.pickupMarkerIcon!,
                                      ),
                                      Marker(
                                        markerId: MarkerId('drop'),
                                        position: controller.orderDetails
                                                        .value['data']
                                                    ['bookingstatus'] ==
                                                'DRIVER ACCEPTED'
                                            ? LatLng(
                                                controller.orderDetails
                                                    .value['data']['pickuplat'],
                                                controller.orderDetails
                                                    .value['data']['pickuplng'])
                                            : LatLng(
                                                controller.orderDetails
                                                    .value['data']['droplat'],
                                                controller.orderDetails
                                                    .value['data']['droplng']),
                                        icon: controller.dropMarkerIcon!,
                                      ),
                                    }
                                  : {},
                              polylines:
                                  controller.polylinesAvailable.value == true
                                      ? Set<Polyline>.of(
                                          controller.polylines.values)
                                      : {},
                            )),
                        Positioned.fill(
                          top: 8,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  color: Colors.black,
                                  iconSize: 34,
                                  icon: const Icon(
                                    Icons.chevron_left,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    controller.orderDetails.value['data']
                                                ['bookingstatus'] ==
                                            'DRIVER ACCEPTED'
                                        ? "reachPickup".tr
                                        : "reachDrop".tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kText22w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 34,
                                  height: 34,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Middle View
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: black,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.orderDetails.value['data']
                                                      ['bookingstatus'] ==
                                                  "DRIVER ACCEPTED"
                                              ? controller.orderDetails
                                                      .value['data']
                                                  ['pickupaddress']
                                              : controller.orderDetails
                                                  .value['data']['dropaddress'],
                                          style: kText14w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Buttons
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: greyShade4,
                                          child: InkWell(
                                            splashColor: Colors.white60,
                                            highlightColor: Colors.transparent,
                                            // splashColor: Colors.grey[200],
                                            onTap: () async {
                                              Uri phoneno = controller
                                                              .orderDetails
                                                              .value['data']
                                                          ['bookingstatus'] ==
                                                      "DRIVER ACCEPTED"
                                                  ? Uri.parse(
                                                      'tel:${controller.orderDetails.value['data']['pickupcontact']}')
                                                  : Uri.parse(
                                                      'tel:${controller.orderDetails.value['data']['recipientcontact']}');
                                              if (await launchUrl(phoneno)) {
                                                //dialer opened
                                              } else {
                                                //dailer is not opened
                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color(0xffDDDDDD),
                                                      blurRadius: 2.0,
                                                      // spreadRadius: 2.0,
                                                      offset: Offset(0.0, 1),
                                                    )
                                                  ],
                                                ),
                                                height: 55,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.phone_outlined,
                                                        color: Colors.black,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        'call'.tr,
                                                        style: kText14w600
                                                            .copyWith(
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: ButtonPrimary(
                                          title: "goToMap".tr,
                                          onPress: () {
                                            controller.handleRouteToGoogleMap();
                                          },
                                          customTextStyle: kText14w600.copyWith(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const VeticalSeperator12(),

                                //Order id
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.bookmark_border_outlined,
                                        color: black,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${"orderId".tr} : ',
                                            style: kText16w400.copyWith(
                                                color: black),
                                          ),
                                          Text(
                                            '${controller.orderDetails.value['data']['bookingno']}',
                                            style: kText16w700.copyWith(
                                                color: black),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const VeticalSeperator12(),

                                if (controller.orderDetails.value['data']
                                        ['bookingstatus'] ==
                                    "PICKUP")
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.info_outline,
                                              color: black,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "deliveryInstructions".tr,
                                                  style: kText16w700.copyWith(
                                                      color:
                                                          black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const VeticalSeperator12(),
                                        Text(
                                            controller.orderDetails
                                                .value['data']['instruction'],
                                            style: kText16w700),
                                      ],
                                    ),
                                  ),
                                const VeticalSeperator12(),

                                //Customer details
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons
                                                .supervised_user_circle_outlined,
                                            color: black,
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${"customerDetails".tr}',
                                                style: kText16w700.copyWith(
                                                    color: black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const VeticalSeperator12(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  "pickupCustomerDetail".tr,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kText12w400.copyWith(
                                                      color: black),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  controller.orderDetails
                                                          .value['data']
                                                      ['pickupname'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kText16w700,
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  controller.orderDetails
                                                          .value['data']
                                                      ['pickupaddress'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kText12w400,
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone_outlined,
                                                      color: orange,
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      controller.orderDetails
                                                              .value['data']
                                                          ['pickupcontact'],
                                                      style: kText14w500,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      if (controller.orderDetails.value['data']
                                              ['bookingstatus'] !=
                                          "DRIVER ACCEPTED")
                                        const SizedBox(
                                          height: 24,
                                        ),
                                      if (controller.orderDetails.value['data']
                                              ['bookingstatus'] !=
                                          "DRIVER ACCEPTED")
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    "recipientCustomerDetails"
                                                        .tr,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kText12w400.copyWith(
                                                        color: greyShade2),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    controller.orderDetails
                                                            .value['data']
                                                        ['recipientname'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kText16w700,
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    controller.orderDetails
                                                            .value['data']
                                                        ['dropaddress'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kText12w400,
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.phone_outlined,
                                                        color: orange,
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        controller.orderDetails
                                                                .value['data'][
                                                            'recipientcontact'],
                                                        style: kText14w500,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),

                  //Buttons
                  controller.orderDetails.value['data']['bookingstatus'] ==
                          'DRIVER ACCEPTED'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ButtonPrimary(
                                onPress: () {
                                  controller.handleReachedPickupLocation();
                                  
                                },
                                title: "reachedPickupLocation".tr,
                                customTextStyle:
                                    kText16w700.copyWith(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextButton(
                                onPress: () {
                                  controller.showCancelBottomSheet(context);
                                },
                                title: "cancelOrder".tr,
                                textStyle: kText16w700.copyWith(color: orange),
                                overlayColor: greyShade4,
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          child: ButtonPrimary(
                            onPress: () {
                              controller.handleReachedDropLocation();
                            },
                            title: "reachedDropLocation".tr,
                            customTextStyle:
                                kText16w700.copyWith(color: Colors.white),
                          ),
                        )
                ],
              )),
      ),
    );
  }
}

class VeticalSeperator12 extends StatelessWidget {
  const VeticalSeperator12({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
    );
  }
}
