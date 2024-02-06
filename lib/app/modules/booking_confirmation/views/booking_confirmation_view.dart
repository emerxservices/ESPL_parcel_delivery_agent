import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../controllers/booking_confirmation_controller.dart';

class BookingConfirmationView extends GetView<BookingConfirmationController> {
  const BookingConfirmationView({Key? key}) : super(key: key);
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Stack(
                      children: [
                        Obx(() => GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                  target: LatLng(0.0, 0.0), zoom: 11.0),
                              zoomControlsEnabled: false,
                              onMapCreated: controller.onMapCreated,
                              markers: controller
                                          .isMapControllerInitialised.value ==
                                      true
                                  ? {
                                      Marker(
                                        markerId: const MarkerId('pickup'),
                                        position: LatLng(
                                            controller.orderDetails
                                                .value['data']['pickuplat'],
                                            controller.orderDetails
                                                .value['data']['pickuplng']),
                                        icon: controller.pickupMarkerIcon!,
                                      ),
                                      Marker(
                                        markerId: MarkerId('drop'),
                                        position: LatLng(
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
                                    "orderDetails".tr,
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
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 21,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      color: lightGrey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    "newOrder".tr,
                                    style: kText16w700,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${'orderId'.tr} ${controller.orderDetails.value['data']['bookingno']}",
                                      textAlign: TextAlign.right,
                                      style: kText16w400
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            VerticalSeperator20(),

                            //Location UI
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: IntrinsicHeight(
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
                                                color: black,
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
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(1,1,1,0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 2),
                                                      child: Text(
                                                        (DateFormat('MMM d, yyyy h:mm a').format(
                                                                DateTime.parse(controller
                                                                            .orderDetails
                                                                            .value["data"]
                                                                        [
                                                                        'createdondate'])
                                                                    .toLocal()))
                                                            .toString(),
                                                        style: kText12w400
                                                            
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        controller.orderDetails
                                                                .value["data"]
                                                            ['pickupaddress'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: kText14w400
                                                            
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
                                            child: Image.asset(
                                                'images/dottedLineWhite.png'),
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
                                            color: black,
                                          ),
                                          const SizedBox(
                                            width: 18.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller.orderDetails
                                                            .value['data']
                                                        ['dropaddress'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: kText14w400
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
                            ),
                            VerticalSeperator20(),

                            //Km minutes Ui
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: 53,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1.0,
                                                  color:black))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${'tripFare'.tr} : ",
                                              style: kText18w400.copyWith(
                                                  color: black),
                                            ),
                                            Text(
                                              "\$ ${controller.orderDetails.value['data']['driverearning'].toString()}",
                                              style: kText18w700.copyWith(
                                                  color: black),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            height: 53,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "pickup".tr,
                                                    style: kText14w400.copyWith(
                                                        color: black),
                                                  ),
                                                  Text(
                                                    '${controller.orderDetails.value['data']['pickupdistance'].toString()} mi',
                                                    style: kText14w600.copyWith(
                                                        color: black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                          Container(
                                            width: 1,
                                            color: black,
                                          ),
                                          Expanded(
                                              child: Container(
                                            height: 53,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "drop".tr,
                                                    style: kText14w400.copyWith(
                                                        color: black),
                                                  ),
                                                  Text(
                                                    '${controller.orderDetails.value['data']['dropdistance'].toString()} mi',
                                                    style: kText14w600.copyWith(
                                                        color: black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 53,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  width: 1.0,
                                                  color: black))),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${'tripDistance'.tr}",
                                              style: kText18w400.copyWith(
                                                  color: black),
                                            ),
                                            Text(
                                              "${controller.orderDetails.value['data']['totaltripdistance'].toString()} mi",
                                              style: kText18w700.copyWith(
                                                  color: black),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            VerticalSeperator20(),

                            //Package Details
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "packageDetails".tr,
                                    style: kText16w700.copyWith(
                                        color: black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${"type".tr} : ',
                                          style: kText14w600.copyWith(
                                              color: black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller
                                                    .orderDetails.value['data']
                                                ['parceltypetitle'],
                                            style: kText14w400.copyWith(
                                                color: black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${"weight".tr} : ',
                                          style: kText14w600.copyWith(
                                              color: black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller.orderDetails
                                                .value['data']['weightslot'],
                                            style: kText14w400.copyWith(
                                                color: black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${"packageDescription".tr} : ',
                                          style: kText14w600.copyWith(
                                              color: black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Expanded(
                                          child: Text(
                                            controller
                                                    .orderDetails.value['data']
                                                ['parceltypedesc'],
                                            style: kText14w400.copyWith(
                                                color: black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Buttons
                  controller.orderDetails.value['data']['bookingstatus'] ==
                          'CREATED'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonPrimary(
                                  title: "reject".tr,
                                  onPress: () {
                                    controller.handleRejectBooking();
                                  },
                                  customTextStyle: kText14w600.copyWith(
                                      color: darkBluePrimary),
                                  backgroundColor: greyShade3,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ButtonPrimary(
                                  title: "accept".tr,
                                  onPress: () {
                                    controller.handleAcceptBooking();
                                  },
                                  customTextStyle:
                                      kText14w600.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                          child: ButtonPrimary(
                            title: "continue".tr,
                            onPress: () {
                              controller.onContinueButtonPress();
                            },
                           
                          ),
                        ),
                ],
              )),
      ),
    );
  }
}

class VerticalSeperator20 extends StatelessWidget {
  const VerticalSeperator20({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
    );
  }
}
