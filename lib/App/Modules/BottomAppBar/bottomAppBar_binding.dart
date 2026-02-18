import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../Profile/profile_controller.dart';
import '../Search/search_controller.dart';
import 'bottomAppBar_controller.dart';

class BottomAppbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomAppbarController>(BottomAppbarController());
    Get.put<ProfileController>(ProfileController());

    // Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<SearchController>(() => SearchController());
    // Get.lazyPut<HotNewsController>(() => HotNewsController());
  }
}