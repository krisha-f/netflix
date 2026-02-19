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

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController());

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text(profile)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// =====================================================
              /// 🎬 CURRENT SELECTED PROFILE (NETFLIX STYLE BIG VIEW)
              /// =====================================================
              Obx(() {
                final currentProfile = controller.profiles.firstWhereOrNull(
                  (p) => p["id"] == controller.selectedProfileId.value,
                );

                final imageBase64 = currentProfile?["image"] ?? "";

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        /// PROFILE IMAGE
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppThemeHelper.textColor(context),
                          child: imageBase64.isNotEmpty
                              ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(imageBase64),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              :
                          Icon(Icons.person,color: AppThemeHelper.reverseTextColor(context),)

                          // Text(
                          //         currentProfile?["name"]?[0] ?? "",
                          //         style: const TextStyle(
                          //           fontSize: 40,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                        ),

                        /// CAMERA ICON (BOTTOM RIGHT)
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              controller
                                  .pickImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Text(
                    controller.storage.userEmail ?? 'No Email',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentProfile?["name"] ?? "Profile",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// EDIT ICON
                        IconButton(
                          onPressed: () {
                            Get.to(() => const EditProfileView());
                          },
                          icon: const Icon(Icons.edit),
                        ),

                        /// DELETE ICON
                        IconButton(
                          onPressed: () {
                            controller.deleteProfile(
                              controller.selectedProfileId.value,
                            );
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              /// =====================================================
              /// 🎬 HORIZONTAL PROFILE LIST
              /// =====================================================
              Obx(() {
                return SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.profiles.length + 1,
                    itemBuilder: (context, index) {
                      /// LAST ITEM = ADD PROFILE (+)
                      if (index == controller.profiles.length) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => CreateProfileView());
                          },
                          child: Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color:  AppThemeHelper.textColor(context)),
                            ),
                            child: const Center(
                              child: Icon(Icons.add, size: 40),
                            ),
                          ),
                        );
                      }

                      final profile = controller.profiles[index];
                      final id = profile["id"];
                      final isSelected =
                          id == controller.selectedProfileId.value;

                      return GestureDetector(
                        onTap: () {
                          controller.switchProfile(id);
                        },
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppThemeHelper.textColor(context)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:  AppThemeHelper.textColor(context),
                                child: profile["image"] != null &&
                                    profile["image"].isNotEmpty
                                    ? ClipOval(
                                  child: Image.memory(
                                    base64Decode(profile["image"]),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : Icon(Icons.person,color: AppThemeHelper.reverseTextColor(context))
                                // Text(
                                //   profile["name"][0],
                                //   style: const TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ),

                             SizedBox(height: 8),

                              Text(
                                profile["name"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// =====================================================
              /// 🔘 DARK MODE
              /// =====================================================
              Obx(
                () => SwitchListTile(
                  title: const Text(darkMode),
                  value: controller.themeController.isDark.value,
                  onChanged: (value) {
                    controller.themeController.toggleTheme();
                  },
                ),
              ),

              /// =====================================================
              /// 📂 MY LIST
              /// =====================================================
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text(myList),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.toNamed(AppRoutes.myList);
                },
              ),

              /// =====================================================
              /// 🚪 LOGOUT
              /// =====================================================
              ListTile(
                leading: Icon(Icons.logout, color: redColor),
                title: Text(logout, style: TextStyle(color: redColor)),
                onTap: () {
                  final authController = Get.put(AuthController());
                  authController.logout();
                  // Get.toNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:netflix/App/Modules/Profile/profile_controller.dart';
// import 'package:netflix/Constant/app_colors.dart';
// import '../../../Constant/app_size.dart';
// import '../../../Constant/app_strings.dart';
// import '../../Data/Services/storage_service.dart';
// import '../../Routes/app_pages.dart';
// import '../Auth/auth_controller.dart';
// import '../MyList/mylist_controller.dart';
// import '../Theme/theme.controller.dart';
// import 'dart:convert';
//
//
// class ProfileView extends GetView<ProfileController>  {
//    ProfileView({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     Get.put(ThemeController());
//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text(profile)),automaticallyImplyLeading: false,),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child:
//
//           Column(
//             children: [
//               Obx(() {
//               final imageBase64 = controller.profileImageBase64.value;
//               return Column(
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey.shade300,
//                         child: imageBase64.isNotEmpty
//                             ? ClipOval(
//                           child: Image.memory(
//                             base64Decode(imageBase64),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                             : const Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Colors.white,
//                         ),
//                       ),
//                       // Obx(() => CircleAvatar(
//                       //   radius: 50,
//                       //   backgroundColor: Colors.grey.shade300,
//                       //   child: controller.profileImageBase64.value.isNotEmpty
//                       //       ? ClipOval(
//                       //     child: Image.memory(
//                       //       base64Decode(
//                       //           controller.profileImageBase64.value),
//                       //       width: 100,
//                       //       height: 100,
//                       //       fit: BoxFit.cover,
//                       //     ),
//                       //   )
//                       //       : const Icon(
//                       //     Icons.person,
//                       //     size: 50,
//                       //     color: Colors.white,
//                       //   ),
//                       // )),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: controller.pickImage,
//                           child: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: const BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     controller.storage.userEmail ?? 'No Email',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//
//
//                 ],
//               );
//             }),
//             // CircleAvatar(
//             //   radius: 50,
//             //   // backgroundImage: AssetImage("assets/profile.png"),
//             // ),
//             // SizedBox(height: size2),
//             //
//             // Text(
//             //   box.read('userEmail') ?? 'No Email',
//             //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             // ),
//
//             SizedBox(height: size2),
//
//             Obx(() => SwitchListTile(
//               title: Text(darkMode),
//               value: controller.themeController.isDark.value,
//               onChanged: (value) {
//                 controller.themeController.toggleTheme();
//               },
//             )),
//
//             ListTile(
//               leading: Icon(Icons.list),
//               title: Text(myList),
//               trailing: Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 Get.toNamed(AppRoutes.myList);
//               },
//             ),
//
//             ListTile(
//               leading: Icon(Icons.logout, color: redColor),
//               title: Text(
//                 logout,
//                 style: TextStyle(color: redColor),
//               ),
//               onTap: () {
//                 final authController = Get.put(AuthController());
//                 authController.logout();
//                 Get.toNamed(AppRoutes.login);
//               },
//             ),
//
//               SizedBox(height: 30),
//
//               ElevatedButton(
//                 onPressed: () {
//                   Get.to(() => CreateProfileView());
//                 },
//                 child: Text("Add Profile"),
//               ),
//
//
//               Obx(() {
//                 return Column(
//                   children: controller.profiles.map((profile) {
//                     final id = profile["id"];
//
//                     return ListTile(
//                       leading: CircleAvatar(
//                         child: Text(profile["name"][0]),
//                       ),
//                       title: Text(profile["name"]),
//                       subtitle: Text(
//                           id == controller.selectedProfileId.value
//                               ? "Current Profile"
//                               : ""),
//
//                       // TAP = SWITCH
//                       onTap: () {
//                         controller.switchProfile(id);
//                       },
//
//                       // MENU
//                       trailing: PopupMenuButton<String>(
//                         onSelected: (value) {
//                           if (value == "edit") {
//                             Get.to(() => EditProfileView());
//                             // EditProfileView();
//                             // controller.editProfile(
//                             //     id, "Edited Name", "");
//                           }
//                           if (value == "delete") {
//                             controller.deleteProfile(id);
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           PopupMenuItem(
//                             value: "edit",
//                             child: Text("Edit"),
//                           ),
//                           PopupMenuItem(
//                             value: "delete",
//                             child: Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }),
//   ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
// }
//
//
class CreateProfileView extends GetView<ProfileController> {
  // final ProfileController controller = Get.find();

  final TextEditingController nameController = TextEditingController();

  RxString imageBase64 = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Profile Name"),
            ),

            // SizedBox(height: 20),

            // Obx(() => GestureDetector(
            //   onTap: controller.pickImageForCreateProfile,
            //   child: CircleAvatar(
            //     radius: 40,
            //     backgroundColor: Colors.grey,
            //     child: controller.tempImageBase64.value.isEmpty
            //         ? const Icon(Icons.person)
            //         : ClipOval(
            //       child: Image.memory(
            //         base64Decode(controller.tempImageBase64.value),
            //         width: 80,
            //         height: 80,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // )),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // CANCEL
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel"),
                ),

                // CREATE
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();

                    if (name.isEmpty) return;

                    // CHECK IF NAME ALREADY EXISTS
                    final alreadyExists = controller.profiles.any(
                      (profile) =>
                          profile["name"].toString().toLowerCase() ==
                          name.toLowerCase(),
                    );

                    if (alreadyExists) {
                      Get.snackbar(
                        "Profile Exists",
                        "Name already taken. Please choose a different name.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    await controller.createProfile(name, imageBase64.value);
                    Get.back();
                    // final name =
                    // nameController.text.trim();
                    //
                    // if (name.isEmpty) return;
                    //
                    // await controller.createProfile(
                    //     name, imageBase64.value);
                    //
                    // Get.back();
                  },
                  child: Text("Create"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔥 PROFILE IMAGE WITH CAMERA ICON
            Obx(
                  () => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                      controller.imageBase64.value.isNotEmpty
                          ? MemoryImage(
                        base64Decode(
                            controller.imageBase64.value),
                      )
                          : null,
                      child: controller.imageBase64.value.isEmpty
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),

                  /// Camera Icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 NAME FIELD
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Profile Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11998E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class EditProfileView extends GetView<ProfileController> {
//   const EditProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             /// IMAGE
//             Obx(
//               () => GestureDetector(
//                 onTap: controller.pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey.shade300,
//                   child: controller.imageBase64.value.isNotEmpty
//                       ? ClipOval(
//                           child: Image.memory(
//                             base64Decode(controller.imageBase64.value),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : const Icon(Icons.person, size: 50),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// NAME
//             TextField(
//               controller: controller.nameController,
//               decoration: const InputDecoration(labelText: "Profile Name"),
//             ),
//
//             const SizedBox(height: 30),
//
//             ElevatedButton(
//               onPressed: controller.updateProfile,
//               child: const Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
