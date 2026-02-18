import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'create_profile_selection_controller.dart';


class CreateProfileSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileSelectionController>(ProfileSelectionController());
  }
}