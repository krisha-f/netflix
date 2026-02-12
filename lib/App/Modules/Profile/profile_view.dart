import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Routes/app_pages.dart';
import '../Auth/auth_controller.dart';
import '../MyList/mylist_controller.dart';
import '../Theme/theme.controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final themeController = Get.find<ThemeController>();
  final myListController = Get.find<MyListController>();
  // final authController = Get.find<AuthController>();


  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// Avatar
            CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage("assets/profile.png"),
            ),

            SizedBox(height: 20),

            /// Dark / Light Toggle
            Obx(() => SwitchListTile(
              title: Text("Dark Mode"),
              value: themeController.isDark.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            )),

            /// My List
            ListTile(
              leading: Icon(Icons.list),
              title: Text("My List"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed(AppRoutes.myList);
              },
            ),

            /// Logout
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
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