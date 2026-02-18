import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Core/Bindings/initial_binding.dart';
import 'App/Data/Services/storage_service.dart';
import 'App/Modules/Theme/theme.controller.dart';
import 'App/Routes/app_pages.dart';

Future<void> main() async {
  runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();


  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBQHUO0uC53q9KoZkeYO1xsst5rNFXvtHU",
          authDomain: "netflix-60f5c.firebaseapp.com",
          databaseURL: "https://netflix-60f5c-default-rtdb.firebaseio.com",
          projectId: "netflix-60f5c",
          storageBucket: "netflix-60f5c.firebasestorage.app",
          messagingSenderId: "591133810178",
          appId: "1:591133810178:web:d62495474022464f97d11b",
          measurementId: "G-K7M30ZLM9E"
        ));
  }
  else{
  await Firebase.initializeApp();}

  await Get.putAsync(() async => StorageService());
  Get.put(ThemeController());

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;


    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDark.value
          ? ThemeMode.dark
          : ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ));
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Find the ThemeController
//     // final themeController = Get.find<ThemeController>();
//
//     // Use Obx to reactively rebuild when theme changes
//
//       return GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Netflix',
//         theme: ThemeData.light(),
//         darkTheme: ThemeData.dark(),
//         themeMode: ThemeMode.system,
//         // themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
//         initialBinding: InitialBinding(),
//         initialRoute: AppPages.initial,
//         getPages: AppPages.routes,
//       );
//   }
// }
