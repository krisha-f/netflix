import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netflix/App/Modules/Profile/profile_controller.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/storage_service.dart';
import '../../Routes/app_pages.dart';
import '../Auth/auth_controller.dart';
import '../MyList/mylist_controller.dart';
import '../Theme/theme.controller.dart';

class ProfileView extends GetView<ProfileController>  {
   ProfileView({super.key});


  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(title: Text(profile)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() {
              return Column(
                children: [
                  Stack(
                    children: [
              CircleAvatar(
              radius: 50,
                backgroundImage: controller.profileImagePath.value.isNotEmpty
                    ? (controller.profileImagePath.value.startsWith('http')
                    ? NetworkImage(controller.profileImagePath.value)
                    : FileImage(File(controller.profileImagePath.value)))
                as ImageProvider
                    : null,
                child: controller.profileImagePath.value.isEmpty
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),

                      // 🔥 Positioned Edit Icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller.pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    controller.storage.userEmail ?? 'No Email',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }),

            // CircleAvatar(
            //   radius: 50,
            //   // backgroundImage: AssetImage("assets/profile.png"),
            // ),
            // SizedBox(height: size2),
            //
            // Text(
            //   box.read('userEmail') ?? 'No Email',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),

            SizedBox(height: size2),

            Obx(() => SwitchListTile(
              title: Text(darkMode),
              value: controller.themeController.isDark.value,
              onChanged: (value) {
                controller.themeController.toggleTheme();
              },
            )),

            ListTile(
              leading: Icon(Icons.list),
              title: Text(myList),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed(AppRoutes.myList);
              },
            ),

            ListTile(
              leading: Icon(Icons.logout, color: redColor),
              title: Text(
                logout,
                style: TextStyle(color: redColor),
              ),
              onTap: () {
                final authController = Get.put(AuthController());
                authController.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}