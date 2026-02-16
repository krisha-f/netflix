import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:netflix/App/Modules/Theme/theme.controller.dart';

import '../../Data/Services/storage_service.dart';
import '../../Modules/Auth/auth_controller.dart';
import '../../Modules/BottomAppBar/bottomAppBar_controller.dart';
import '../../Modules/Download/download_controller.dart';
import '../../Modules/Home/home_controller.dart';
import '../../Modules/HotNews/hotnews_controller.dart';
import '../../Modules/Movie_details/movie_details_controller.dart';
import '../../Modules/MyList/mylist_controller.dart';
import '../../Modules/Profile/profile_controller.dart';
import '../../Modules/Search/search_controller.dart';
import '../../Modules/Splash/splash_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<HomeController>(HomeController());
    // Get.put<MyListController>(MyListController());
    Get.put(SplashController());
    Get.put(ThemeController());

    // Get.put(AuthController());
    Get.put(MyListController());
    Get.put(BottomAppbarController());
    Get.put(HomeController());
    Get.put<DownloadController>(DownloadController(),permanent: true);

    // Get.put(MovieDetailsController());
    // Get.put(MyListController());
    Get.put(SearchController());
    Get.put(HotNewsController());
    Get.put(ProfileController());

  }
}