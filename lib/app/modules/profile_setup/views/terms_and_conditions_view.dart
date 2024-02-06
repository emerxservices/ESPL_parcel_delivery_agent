import 'package:espl_parcel_driver/app/components/buttonPrimary.dart';
import 'package:espl_parcel_driver/app/components/customMultiAppbar.dart';
import 'package:espl_parcel_driver/app/modules/profile_setup/controllers/profile_setup_controller.dart';
import 'package:espl_parcel_driver/app/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TermsAndConditionsView extends GetView<ProfileSetupController> {
  const TermsAndConditionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomMultiAppbar(
          title: "",
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'carefullyReadAllTAndC'.tr,
                style: kText24w700.copyWith(color: orange),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight - 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. At orci, orci sed vitae. ",
                            style:
                                kText18w400.copyWith(color: lightGreySecondary),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Egestas eu sit ac cras egestas nisi. Adipiscing a adipiscing non aliquet sapien pharetra, metus volutpat senectus. Nisl placerat dictum purus cursus. Ultrices ultrices erat fermentum sed condimentum quam elementum, imperdiet. Tincidunt sagittis suspendisse nunc in lacus diam quisque dui, sapien. Sodales lectus ut risus, viverra amet nisi adipiscing. Blandit.",
                            style:
                                kText18w400.copyWith(color: lightGreySecondary),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: Obx(
                                  () => Checkbox(
                                    activeColor: orange,
                                    value: controller
                                        .acceptedTermsAndConditions.value,
                                    onChanged: (bool? value) {
                                      controller.acceptedTermsAndConditions
                                          .value = value!;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  'agreedTermsText'.tr,
                                  style: kText18w600.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          ButtonPrimary(
                            onPress: () async {
                              if (controller.acceptedTermsAndConditions.value ==
                                  true) {
                                controller.goToCongratulations();
                              }
                            },
                            title: 'goToHomePage'.tr,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
