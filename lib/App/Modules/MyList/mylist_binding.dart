import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'mylist_controller.dart';

class MyListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyListController>(MyListController());
  }
}