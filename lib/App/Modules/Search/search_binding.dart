import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:netflix/App/Modules/Search/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchController>(SearchController());
  }
}