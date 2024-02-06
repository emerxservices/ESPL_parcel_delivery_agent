import 'package:get/get.dart';

import '../controllers/reached_pickup_destination_controller.dart';

class ReachedPickupDestinationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ReachedPickupDestinationController());
  }
}
