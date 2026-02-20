import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netflix/App/Modules/Profile/profile_controller.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Routes/app_pages.dart';
import '../Auth/auth_controller.dart';
import '../Theme/theme.controller.dart';
import 'dart:convert';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(ThemeController());

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
              Obx(() {
                final currentProfile = controller.profiles.firstWhereOrNull(
                  (p) => p["id"] == controller.selectedProfileId.value,
                );

                final imageBase64 = currentProfile?["imageBase64"] ?? "";

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppThemeHelper.textColor(context),
                    child: buildSafeAvatar(
                      imageBase64,
                      radius: 60,
                    ),
                        ),

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

                        IconButton(
                          onPressed: () {
                            controller.loadSelectedProfileForEdit();
                            Get.to(() => const EditProfileView());
                          },
                          icon: const Icon(Icons.edit),
                        ),

                        IconButton(
                          onPressed: () {
                            controller.deleteProfile(
                              controller.selectedProfileId.value ,
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

           Obx(()=>
             SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.profiles.length + 1,
                    itemBuilder: (context, index) {
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

                      if (index >= controller.profiles.length) {
                        return const SizedBox();
                      }

                      final profile = controller.profiles[index];
                      final id = profile["id"];
                      // final isSelected =
                      //     id == controller.profileId;
                      final isSelected =
                          id == controller.selectedProfileId.value;
                      return GestureDetector(
                        onTap: () {
                          controller.selectedProfileId.value = id;
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
                                child: buildSafeAvatar(
                                  profile["imageBase64"],
                                  radius: 30,
                                ),
                                // profile["imageBase64"] != null &&
                                //     profile["imageBase64"].toString().isNotEmpty
                                //     ? ClipOval(
                                //   child: Image.memory(
                                //     base64Decode(profile["imageBase64"]),
                                //     width: 60,
                                //     height: 60,
                                //     fit: BoxFit.cover,
                                //   ),
                                // )
                                //     : Icon(Icons.person,color: AppThemeHelper.reverseTextColor(context))
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
                ),
           ),

              const SizedBox(height: 30),

              Obx(
                () => SwitchListTile(
                  title: const Text(darkMode),
                  value: controller.themeController.isDark.value,
                  onChanged: (value) {
                    controller.themeController.toggleTheme();
                  },
                ),
              ),

              ListTile(
                leading: const Icon(Icons.list),
                title: const Text(myList),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.toNamed(AppRoutes.myList);
                },
              ),

              ListTile(
                leading: Icon(Icons.logout, color: redColor),
                title: Text(logout, style: TextStyle(color: redColor)),
                onTap: () {
                  controller.logout();
                  // final authController = Get.find<AuthController>();
                  // // final authController = Get.put(AuthController());
                  // authController.logout();
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

// class CreateProfileView extends GetView<ProfileController> {
//   // final ProfileController controller = Get.find();
//
//   final TextEditingController nameController = TextEditingController();
//
//   RxString imageBase64 = ''.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Create Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "Profile Name"),
//             ),
//             SizedBox(height: 20),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   child: Text("Cancel"),
//                 ),
//
//                 ElevatedButton(
//                   onPressed: () async {
//                     final name = nameController.text.trim();
//
//                     if (name.isEmpty) return;
//
//                     final alreadyExists = controller.profiles.any(
//                       (profile) =>
//                           profile["name"].toString().toLowerCase() ==
//                           name.toLowerCase(),
//                     );
//
//                     if (alreadyExists) {
//                       Get.snackbar(
//                         "Profile Exists",
//                         "Name already taken. Please choose a different name.",
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                       return;
//                     }
//
//                     await controller.createProfile(name, imageBase64.value);
//                     Get.back();
//                   },
//                   child: Text("Create"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CreateProfileView extends GetView<ProfileController> {
  const CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    RxString imageBase64 = ''.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Obx(
            //       () => Stack(
            //     alignment: Alignment.bottomRight,
            //     children: [
            //       GestureDetector(
            //         onTap: () async {
            //           final XFile? image =
            //           await controller._picker
            //               .pickImage(
            //               source: ImageSource.gallery);
            //
            //           if (image == null) return;
            //
            //           File file = File(image.path);
            //           final bytes =
            //           await file.readAsBytes();
            //
            //           imageBase64.value =
            //               base64Encode(bytes);
            //         },
            //         child: CircleAvatar(
            //           radius: 55,
            //           backgroundColor:
            //           Colors.grey.shade200,
            //           backgroundImage:
            //           imageBase64.value.isNotEmpty
            //               ? MemoryImage(
            //             base64Decode(
            //                 imageBase64.value),
            //           )
            //               : null,
            //           child: imageBase64.value.isEmpty
            //               ? const Icon(Icons.person,
            //               size: 50)
            //               : null,
            //         ),
            //       ),
            //
            //       const Icon(Icons.camera_alt,
            //           color: Colors.black),
            //     ],
            //   ),
            // ),
            //
            // const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Profile Name",
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final name =
                  nameController.text.trim();

                  if (name.isEmpty) return;

                  await controller.createProfile(
                      name, imageBase64.value);

                  Get.back();
                },
                child:
                const Text("Create Profile"),
              ),
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


Widget buildSafeAvatar(String? imageBase64,
    {double radius = 40}) {
  if (imageBase64 == null || imageBase64.isEmpty) {
    return Icon(Icons.person, size: radius);
  }

  try {
    return ClipOval(
      child: Image.memory(
        base64Decode(imageBase64),
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
      ),
    );
  } catch (_) {
    return Icon(Icons.person, size: radius);
  }
}

