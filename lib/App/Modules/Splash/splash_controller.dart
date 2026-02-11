
// import 'package:get/get.dart';
//
// class SplashController extends GetxController{
//
//   // final storage = Get.find<StorageService>();
//
//
//   @override
//   void onInit() {
//     // checkFlow();
//     super.onInit();
//   }
//
//
//   // void checkFlow() async {
//   //   await Future.delayed(const Duration(seconds: 2));
//   //   if (!await NetworkService.hasInternet()) {
//   //     Get.offAllNamed(Routes.NO_INTERNET);
//   //   } else if (storage.isLoggedIn) {
//   //     Get.offAllNamed(Routes.HOME);
//   //   } else {
//   //     Get.offAllNamed(Routes.LOGIN);
//   //   }
//   // }
// }

import 'dart:async';
import 'package:get/get.dart';
import '../../Data/Services/storage_service.dart';
import '../../Routes/app_pages.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  Future<void> _startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(AppRoutes.bottomAppBar);
    // Timer(const Duration(seconds: 4), () async {
    //   Get.offAllNamed(AppRoutes.login);
    //   // await _handleNavigation();
    // });
  }

  Future<void> _handleNavigation() async {
      Get.offAllNamed(AppRoutes.login);
  }
}