import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.loadingData.value == true
        ? Container(
            color: greyShade3,
            child: const Center(
              child: CircularProgressIndicator(
                color: orangePrimary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: greyShade3,
            appBar: CustomMultiAppbar(
              title: 'orderDetails'.tr,
              // appBarBackgroundColor: greyShade3,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const VerticalSeperator10(),
                        controller.orderDetails.value['data']
                                    ['bookingstatus'] ==
                                "DELIVERED"
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: bgBox,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'packageDeliveredSafely'.tr,
                                      style: kText18w600.copyWith(
                                          color: black),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            radius: 25.0,
                                            backgroundImage: NetworkImage(
                                                "$BASE_URL/defaultImg/default_customer_img.png")),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "deliveredTo".tr,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: kText12w400.copyWith(
                                                    color: black),
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                controller.orderDetails
                                                        .value['data']
                                                    ['recipientname'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: kText14w600.copyWith(
                                                    color: black),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        BoxContainer(
                          child: //Location UI
                              IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 44,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 14.0,
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
                                                        ['pickupaddress'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                      top: 25,
                                      left: 11.5,
                                      child: Container(
                                        height: 40.0,
                                        child: Image.asset(
                                            'images/dottedLine.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  height: 44,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 14.0,
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
                        ),
                        controller.orderDetails.value['data']['pickupimage'] !=
                                null
                            ? BoxContainer(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "billAndItemImage".tr,
                                      style: kText18w600.copyWith(
                                          color: Colors.black),
                                    ),
                                    VerticalSeperator10(),
                                    Wrap(
                                      spacing: 2.0,
                                      runSpacing: 2.0,
                                      children: [
                                        Card(
                                          clipBehavior: Clip.hardEdge,
                                          child: Container(
                                            height: 84,
                                            width: 69,
                                            child: Image.network(
                                              '$BASE_URL${controller.orderDetails.value['data']['pickupimage']}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        BoxContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "orderDetails".tr,
                                style:
                                    kText18w600.copyWith(color: Colors.black),
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
                        controller.orderDetails.value['data']
                                    ['bookingstatus'] ==
                                "DELIVERED"
                            ? BoxContainer(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.bookmark_border_outlined),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${"paymentStatus".tr} : ${controller.orderDetails.value['data']['paymentstatus']}',
                                      style: kText18w600,
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                    child: Text(
                                  "cancelled".tr,
                                  style: kText20w700.copyWith(color: orange),
                                )),
                              ),
                      ],
                    )),
              ),
            ),
          ));
  }
}

class BoxContainer extends StatelessWidget {
  BoxContainer({required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: child,
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
