import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:netflix/App/Modules/Theme/theme.controller.dart';
import '../../Modules/Auth/auth_controller.dart';
import '../../Modules/BottomAppBar/bottomAppBar_controller.dart';
import '../../Modules/CreateProfileSelection/create_profile_selection_controller.dart';
import '../../Modules/Download/download_controller.dart';
import '../../Modules/Home/home_controller.dart';
import '../../Modules/HotNews/hotnews_controller.dart';
import '../../Modules/MyList/mylist_controller.dart';
import '../../Modules/Profile/profile_controller.dart';
import '../../Modules/Search/search_controller.dart';
import '../../Modules/Splash/splash_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<CustomSearchController>(() => CustomSearchController());
    Get.lazyPut<MyListController>(() => MyListController());
    Get.lazyPut<BottomAppbarController>(() => BottomAppbarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DownloadController>(() => DownloadController());
    Get.lazyPut<HotNewsController>(() => HotNewsController());
    // Get.lazyPut<ProfileController>(() => ProfileController());
    Get.put(ProfileController(), permanent: true);
    // Get.lazyPut<ProfileSelectionController>(()=>ProfileSelectionController());
  }
}