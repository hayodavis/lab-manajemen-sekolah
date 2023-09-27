import 'package:get/get.dart';

import '../controllers/edit_inventory_controller.dart';

class EditInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditInventoryController>(
      () => EditInventoryController(),
    );
  }
}
