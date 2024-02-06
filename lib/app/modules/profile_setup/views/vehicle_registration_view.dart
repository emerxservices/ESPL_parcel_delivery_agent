import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customBox.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/components/textInputBox.dart';
import 'package:espl_parcel_driver/app/modules/profile_setup/controllers/profile_setup_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class VehicleRegistrationView extends GetView<ProfileSetupController> {
  VehicleRegistrationView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: controller.backButtonPressOfVehicleRegistration,
        child: Form(
          key: _formKey,
          child: SafeArea(
              child: Scaffold(
            appBar: CustomMultiAppbar(
              title: 'vehicleRegistration'.tr,
              onLeadingIconButtonPress: () {
                controller.backButtonPressOfVehicleRegistration();
              },
            ),
            body: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight - 40),
                    child: Column(
                      children: [
                        // TextInputBox(
                        //   controller: controller.vehicleNameInputController,
                        //   placeHolder: 'vehicleName'.tr,
                        //   onValueChange: (value) {},
                        //   validationType: "vehicleName",
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        TextInputBox(
                          controller:
                              controller.vehicleRegNumberInputController,
                          placeHolder: 'vehicleRegistrationNo'.tr,
                          onValueChange: (value) {},
                          validationType: "vehicleRegNo",
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ButtonPrimary(
                          onPress: () {
                            // Get.back;

                            if (_formKey.currentState!.validate()) {
                              controller.handleVehicleRegistration();
                              // uploadVehicleDetails(
                              //     vehicleTypeId,
                              //     profileController.vehicleNameInputController.text,
                              //     profileController
                              //         .vehicleRegNumberInputController.text);
                            }
                          },
                          title: 'next'.tr,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
        ));
  }
}
