import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:netflix/App/Modules/Watchlist/watchList_controller.dart';

class WatchlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WatchlistController>(WatchlistController());
  }
}