import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'download_controller.dart';

class DownloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DownloadController());
  }
}