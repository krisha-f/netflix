import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../Data/Services/storage_service.dart';

class ThemeController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      isDark.value = storage.isDarkMode;
      applyTheme();
      return;
    }

    final snapshot =
    await database.child("users/$uid/theme").get();

    if (snapshot.exists) {
      isDark.value = snapshot.value as bool;
      storage.saveTheme(isDark.value);
    } else {
      isDark.value = storage.isDarkMode;
    }

    applyTheme();
  }

  Future<void> toggleTheme() async {
    isDark.value = !isDark.value;

    applyTheme();

    storage.saveTheme(isDark.value);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await database.child("users/$uid").update({
      "theme": isDark.value,
    });
  }

  void applyTheme() {
    Get.changeThemeMode(
      isDark.value ? ThemeMode.dark : ThemeMode.light,
    );
  }
  Future<void> reloadThemeAfterLogin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
    await database.child("users/$uid/theme").get();

    if (snapshot.exists) {
      isDark.value = snapshot.value as bool;
      applyTheme();
    }
  }

}


// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:flutter/material.dart';
//
// import '../../Data/Services/storage_service.dart';
//
// class ThemeController extends GetxController {
//   // final box = GetStorage();
//   final storage = Get.find<StorageService>();
//
//   var isDark = true.obs;
//
//   @override
//   // void onInit() {
//   //   super.onInit();
//   //
//   //   isDark.value = box.read('isDark') ?? true;
//   //
//   //   Get.changeThemeMode(
//   //     isDark.value ? ThemeMode.dark : ThemeMode.light,
//   //   );
//   // }
//   //
//   // void toggleTheme() {
//   //   isDark.value = !isDark.value;
//   //
//   //   box.write('isDark', isDark.value);
//   //
//   //   Get.changeThemeMode(
//   //     isDark.value ? ThemeMode.dark : ThemeMode.light,
//   //   );
//   // }
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     isDark.value = storage.isDarkMode;
//
//     Get.changeThemeMode(
//       isDark.value ? ThemeMode.dark : ThemeMode.light,
//     );
//   }
//
//   void toggleTheme() {
//     isDark.value = !isDark.value;
//
//     storage.saveTheme(isDark.value);
//
//     Get.changeThemeMode(
//       isDark.value ? ThemeMode.dark : ThemeMode.light,
//     );
//   }
//
// }