import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../../Data/Services/storage_service.dart';

class ThemeController extends GetxController {
  // final box = GetStorage();
  final storage = Get.find<StorageService>();

  var isDark = true.obs;

  @override
  // void onInit() {
  //   super.onInit();
  //
  //   isDark.value = box.read('isDark') ?? true;
  //
  //   Get.changeThemeMode(
  //     isDark.value ? ThemeMode.dark : ThemeMode.light,
  //   );
  // }
  //
  // void toggleTheme() {
  //   isDark.value = !isDark.value;
  //
  //   box.write('isDark', isDark.value);
  //
  //   Get.changeThemeMode(
  //     isDark.value ? ThemeMode.dark : ThemeMode.light,
  //   );
  // }


  @override
  void onInit() {
    super.onInit();
    isDark.value = storage.isDarkMode;

    Get.changeThemeMode(
      isDark.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggleTheme() {
    isDark.value = !isDark.value;

    storage.saveTheme(isDark.value);

    Get.changeThemeMode(
      isDark.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

}