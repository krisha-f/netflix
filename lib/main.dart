import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Core/Bindings/initial_binding.dart';
import 'App/Modules/Theme/theme.controller.dart';
import 'App/Routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController(),);

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
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  runZonedGuarded(() {
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
    return GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeController>().isDark.value
          ? ThemeMode.dark
          : ThemeMode.light,
      title: 'Netflix',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.deepPurple,
      //   ),
      // ),
      initialRoute: AppPages.initial,
      initialBinding : InitialBinding(),
      getPages: AppPages.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text(""),
          ],
        ),
      ),
    );
  }
}
