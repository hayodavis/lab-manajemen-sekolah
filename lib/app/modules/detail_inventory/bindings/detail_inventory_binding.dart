import 'package:get/get.dart';

import '../controllers/detail_inventory_controller.dart';

class DetailInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailInventoryController>(
      () => DetailInventoryController(),
    );
  }
}
