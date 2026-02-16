import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../Download/download_controller.dart';
import '../MyList/mylist_controller.dart';
import 'home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<MyListController>(MyListController());
    // Get.put<DownloadController>(DownloadController());

  }
}