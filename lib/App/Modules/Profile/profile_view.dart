import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:netflix/App/Modules/Profile/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      // body: ListTile(
      //   title: const Text('Settings'),
      //   onTap: () => Get.toNamed(Routes.SETTINGS),
      // ),
    );
  }
}