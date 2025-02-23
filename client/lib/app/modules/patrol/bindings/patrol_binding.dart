import 'package:get/get.dart';

import '../controllers/patrol_controller.dart';

class PatrolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatrolController>(
      () => PatrolController(),
    );
  }
}
