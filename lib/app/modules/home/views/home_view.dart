import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customAppbar.dart';
import 'package:espl_parcel_driver/app/modules/home/views/sidemenu_view.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "home".tr,
        onlineStatus: controller.onlineStatus,
        onSwitchPress: (val) {
          controller.onlineStatus.value = val;
          controller.setOnlineStatus();
        },
        onLeadingIconPress: () {},
      ),
      drawer: Sidemenu(controller: controller),
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(controller.currentLatitude.value,
                      controller.currentLongitude.value),
                  zoom: 14.0),
              onMapCreated: controller.onMapCreated,
              markers: controller.mapCreated.value == true
                  ? {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: LatLng(controller.currentLatitude.value,
                            controller.currentLongitude.value),
                        icon: controller.CurrentLocationMarkerIcon!,
                      )
                    }
                  : {},
              zoomControlsEnabled: false,
            ),
          ),
          Obx(
            () => controller.profileApprovedByAdmin.value == false
                ? Positioned(
                    top: 14,
                    left: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.only(
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
                  )
                : Container(),
          ),
          Obx(() => DraggableScrollableSheet(
                initialChildSize:
                    controller.onlineStatus.value == true ? .15 : .2492,
                minChildSize: controller.onlineStatus.value == true ? .07 : .15,
                maxChildSize:
                    controller.onlineStatus.value == true ? .15 : .2492,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ListView(
                    controller: scrollController,
                    children: [
                      Obx(() => controller.onlineStatus.value == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ButtonPrimary(
                                onPress: () {
                                  controller.onlineStatus.value = true;
                                  controller.setOnlineStatus();
                                },
                                title: 'goOnline'.tr,
                              ),
                            )
                          : Container()),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                height: 5,
                                width: 80,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: greyShade2,
                                ),
                              ),
                            ),
                            Obx(
                              () => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: Text(
                                    controller.onlineStatus.value == true
                                        ? 'youROnline'.tr
                                        : 'youROffline'.tr,
                                    style: kText24w700.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: darkBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
