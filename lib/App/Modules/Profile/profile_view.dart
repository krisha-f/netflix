import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_size.dart';
import '../../../Constant/app_strings.dart';
import '../../Routes/app_pages.dart';
import '../MyList/mylist_controller.dart';
import '../Theme/theme.controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final themeController = Get.find<ThemeController>();
  final myListController = Get.find<MyListController>();
  // final authController = Get.find<AuthController>();
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  RxString profileImagePath = ''.obs;
  Future<void> pickImage() async {
    final email = box.read('userEmail');
    if (email == null) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImagePath.value = image.path;
      box.write(email, image.path);
    }
  }

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
                        backgroundImage: profileImagePath.value.isNotEmpty
                            ? FileImage(File(profileImagePath.value))
                            : null,
                        child: profileImagePath.value.isEmpty
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),

                      // 🔥 Positioned Edit Icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                           pickImage();
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
                    box.read('userEmail') ?? 'No Email',
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
              value: themeController.isDark.value,
              onChanged: (value) {
                themeController.toggleTheme();
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
                // authController.logout();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}