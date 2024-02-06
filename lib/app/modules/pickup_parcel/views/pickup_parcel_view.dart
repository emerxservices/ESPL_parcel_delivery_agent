import 'dart:io';

import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/pickup_parcel_controller.dart';

class PickupParcelView extends GetView<PickupParcelController> {
  PickupParcelView({Key? key}) : super(key: key);

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadingData.value == true
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(
                color: orangePrimary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: CustomMultiAppbar(
                title: controller.orderDetails.value['data']['bookingstatus'] ==
                        'REACHED PICKUP LOCATION'
                    ? 'pickParcel'.tr
                    : 'dropParcel'.tr),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.orderDetails.value['data']
                                  ['bookingstatus'] ==
                              'REACHED PICKUP LOCATION')
                            Container(
                              height: 59,
                              // width: double.infinity,
                              decoration: BoxDecoration(
                                color: bgBox,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'pickOrderIn2Mins'.tr,
                                    style: kText18w600.copyWith(
                                        color: black),
                                  )
                                ],
                              ),
                            ),

                          if (controller.orderDetails.value['data']
                                  ['bookingstatus'] ==
                              'REACHED PICKUP LOCATION')
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  Text(
                                    "orderId".tr,
                                    style: kText20w700.copyWith(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    controller.orderDetails.value['data']
                                        ['bookingno'],
                                    style: kText24w700,
                                  ),
                                ],
                              ),
                            ),

                          if (controller.orderDetails.value['data']
                                  ['bookingstatus'] ==
                              'REACHED PICKUP LOCATION')
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, right: 16, bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${'itemImages'.tr}',
                                        style: kText18w600,
                                      ),
                                      Tooltip(
                                        key: tooltipkey,
                                        triggerMode: TooltipTriggerMode.manual,
                                        showDuration:
                                            const Duration(seconds: 1),
                                        message: 'I am a Tooltip',
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        splashRadius: 20,
                                        iconSize: 20,
                                        icon: const Icon(
                                            Icons.help_outline_outlined),
                                        onPressed: () {
                                          tooltipkey.currentState
                                              ?.ensureTooltipVisible();
                                        },
                                      ),
                                    ],
                                  ),
                                  Obx(() => controller
                                          .temporaryImage.value.isNotEmpty
                                      ? Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Card(
                                              clipBehavior: Clip.hardEdge,
                                              child: Container(
                                                height: 84,
                                                width: 69,
                                                child: Image.file(
                                                  File(controller
                                                      .temporaryImage.value),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -4,
                                              right: -4,
                                              child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: orange,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  onPressed: () {
                                                    controller.temporaryImage
                                                        .value = "";
                                                    print(
                                                        "Close button pressed");
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Material(
                                              type: MaterialType.circle,
                                              color: Colors.red,
                                              child: Ink(
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: orange,
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                  iconSize: 30,
                                                  icon: const Icon(Icons.add),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    controller.getImage(
                                                        ImageSource.camera);
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                ],
                              ),
                            ),

                          if (controller.orderDetails.value['data']
                                  ['bookingstatus'] !=
                              'REACHED PICKUP LOCATION')
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, right: 16, bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.bookmark_border_outlined),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${"paymentStatus".tr} : ${controller.orderDetails.value['data']['paymentstatus']}',
                                          style: kText18w600,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              '${"orderId".tr} : ',
                                              style: kText14w400.copyWith(
                                                  color: lightGreySecondary),
                                            ),
                                            Text(
                                              '${controller.orderDetails.value['data']['bookingno']}',
                                              style: kText14w600.copyWith(
                                                  color: lightGreySecondary),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),

                          VerticalSeperator10(),

                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, right: 16, bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "orderDetails".tr,
                                  style:
                                      kText16w700.copyWith(color: Colors.black),
                                ),
                                VerticalSeperator10(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.text_snippet_outlined,
                                      color: lightGreySecondary,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "document".tr,
                                          style: kText14w600.copyWith(
                                              color: lightGreySecondary),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${"parcelType".tr} : ${controller.orderDetails.value['data']['parceltypetitle']}',
                                          style: kText12w400,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${"weight".tr} : ${controller.orderDetails.value['data']['weightslot']}',
                                          style: kText12w400,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          VerticalSeperator10(),

                          //Customer details
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, right: 16, bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.supervised_user_circle_outlined,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${"customerDetails".tr}',
                                          style: kText16w700.copyWith(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const VerticalSeperator10(),
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
                                            overflow: TextOverflow.ellipsis,
                                            style: kText12w400.copyWith(
                                                color: greyShade2),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            controller.orderDetails
                                                .value['data']['pickupname'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kText16w700,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            controller.orderDetails
                                                .value['data']['pickupaddress'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "recipientCustomerDetails".tr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kText12w400.copyWith(
                                                color: greyShade2),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            controller.orderDetails
                                                .value['data']['recipientname'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kText16w700,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            controller.orderDetails
                                                .value['data']['dropaddress'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                                                    ['recipientcontact'],
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
                      ),
                    ),
                  ),
                  if (controller.orderDetails.value['data']['bookingstatus'] ==
                      'REACHED PICKUP LOCATION')
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: orange,
                            child: InkWell(
                              splashColor: Colors.white60,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),

                              // splashColor: Colors.grey[200],
                              onTap: () {
                                controller.handleUploadPickedParcelImage();
                              },
                              child: Container(
                                  height: 55,
                                  child: Center(
                                    child: Text(
                                      'pickedParcel'.tr,
                                      style: kText18w700.copyWith(
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        VerticalSeperator7(),
                        Material(
                          borderRadius: BorderRadius.circular(10.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),

                            splashColor: lightOrange,
                            highlightColor: Colors.transparent,
                            // splashColor: Colors.grey[200],
                            onTap: () {
                              controller.showCancelBottomSheet(context);
                            },
                            child: Container(
                                height: 55,
                                child: Center(
                                    child: Text('cancelOrder'.tr,
                                        style: kText18w700.copyWith(
                                            color: orange)))),
                          ),
                        )
                      ],
                    ),
                  if (controller.orderDetails.value['data']['bookingstatus'] !=
                      'REACHED PICKUP LOCATION')
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: orange,
                            child: InkWell(
                              splashColor: Colors.white60,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              // splashColor: Colors.grey[200],
                              onTap: () {
                                controller.handelParcelDelivered();
                              },
                              child: Container(
                                  height: 55,
                                  child: Center(
                                    child: Text(
                                      'parcelDelivered'.tr,
                                      style: kText18w700.copyWith(
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ));
  }
}

class VerticalSeperator7 extends StatelessWidget {
  const VerticalSeperator7({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 7,
    );
  }
}

class VerticalSeperator20 extends StatelessWidget {
  const VerticalSeperator20({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
    );
  }
}

class VerticalSeperator10 extends StatelessWidget {
  const VerticalSeperator10({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
    );
  }
}
