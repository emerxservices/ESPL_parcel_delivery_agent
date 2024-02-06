import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/location_permission_controller.dart';

class LocationPermissionView extends GetView<LocationPermissionController> {
  const LocationPermissionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: orangePrimary,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Location not found",
                style: kText24w700,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'It seems you haven\'t switched on your device location or not given persmission. This app requires locations permissions to be set to "Allow all the time" to get new bookings',
                style: kText16w700.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              ButtonPrimary(
                onPress: () {
                  controller.requestPermission();
                },
                title: "Enable Location",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
