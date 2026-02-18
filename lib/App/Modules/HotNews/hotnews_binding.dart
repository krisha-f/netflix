import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'hotnews_controller.dart';

class HotNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotNewsController>(() => HotNewsController());

    // Get.put<HotNewsController>(HotNewsController());
  }
}
