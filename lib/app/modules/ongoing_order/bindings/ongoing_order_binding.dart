import 'package:get/get.dart';

import '../controllers/ongoing_order_controller.dart';

class OngoingOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OngoingOrderController());
  }
}
