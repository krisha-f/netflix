import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_profile_selection_controller.dart';

class ProfileSelectionView
    extends GetView<ProfileSelectionController> {
  const ProfileSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Who's Watching?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            GridView.builder(
              shrinkWrap: true,
              itemCount: controller.profiles.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (_, index) {
                final profile = controller.profiles[index];

                return GestureDetector(
                  onTap: () =>
                      controller.selectProfile(profile["id"]),
                  child: Column(
                    children: [
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundColor: Colors.grey[800],
                      //   child: const Icon(
                      //     Icons.person,
                      //     color: Colors.white,
                      //     size: 40,
                      //   ),
                      // ),
                      profile["imageBase64"] != null &&
                          profile["imageBase64"].toString().isNotEmpty
                          ? ClipOval(
                        child: Image.memory(
                          base64Decode(
                              profile["imageBase64"].toString()),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),

                      const SizedBox(height: 10),
                      Text(
                        profile["name"] ?? "",
                        style: const TextStyle(
                            color: Colors.white),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        );
      }),
    );
  }
}