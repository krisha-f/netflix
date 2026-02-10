import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix/App/Modules/Settings/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  // final storage = Get.find<StorageService>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("settings")
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Settings')),
  //     body: ListTile(
  //       title: const Text('Logout'),
  //       onTap: () async {
  //         await storage.logout();
  //         Get.offAllNamed(Routes.LOGIN);
  //       },
  //     ),
  //   );
  // }
}