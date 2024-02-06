import 'package:get/get.dart';

import '../controllers/pickup_parcel_controller.dart';

class PickupParcelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickupParcelController>(
      () => PickupParcelController(),
    );
  }
}
