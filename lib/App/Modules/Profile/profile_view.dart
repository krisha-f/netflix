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
import 'dart:convert';


class ProfileView extends GetView<ProfileController>  {
   ProfileView({super.key});


  @override
  Widget build(BuildContext context) {

    Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(title: Text(profile)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(() {
                final imageBase64 = controller.profileImageBase64.value;

                return Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          child: imageBase64.isNotEmpty
                              ? ClipOval(
                            child: Image.memory(
                              base64Decode(imageBase64),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.storage.userEmail ?? 'No Email',
                      style: const TextStyle(
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
      ),
    );
  }
}