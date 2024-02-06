import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/notificationCard.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMultiAppbar(
        title: 'notification'.tr,
      ),
      body: Obx(() => controller.loadingData.value == true
          ? const Center(
              child: CircularProgressIndicator(
                color: orangePrimary,
              ),
            )
          : Container(
              child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(20.0),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      title: controller.notifications[index].notificationtitle!,
                      description:
                          controller.notifications[index].notificationbody!,
                      createdOnDate:
                          controller.notifications[index].createdondate!,
                    );
                  }),
            )),
    );
  }
}
