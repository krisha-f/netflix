
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
  final StorageService storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(const Duration(seconds: 2), () async {
      await _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    // final hasInternet = await NetworkService.hasInternet();
    //
    // if (!hasInternet) {
    //   Get.offAllNamed(Routes.NO_INTERNET);
    //   return;
    // }

    // if (storageService.isLoggedIn) {
    //   Get.offAllNamed(AppRoutes.splash);
    // } else {
      Get.offAllNamed(AppRoutes.login);
    // }
  }
}