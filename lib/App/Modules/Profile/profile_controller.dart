import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Data/Services/storage_service.dart';
import '../Download/download_controller.dart';
import '../MyList/mylist_controller.dart';
import '../Theme/theme.controller.dart';

class ProfileController extends GetxController {
  final themeController = Get.find<ThemeController>();
  final storage = Get.find<StorageService>();

  final ImagePicker _picker = ImagePicker();
  final database = FirebaseDatabase.instance.ref();

  RxString profileImageBase64 = ''.obs;
  RxString userEmail = ''.obs;
  // RxString themeMode = ''.obs;
  RxBool themeMode = false.obs;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get profileId => storage.selectedProfileId;

  RxString selectedProfileId = ''.obs;

  RxString profileName = 'Main'.obs;
  RxList<Map<String, dynamic>> profiles = <Map<String, dynamic>>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // RxString tempImageBase64 = ''.obs;
  final nameController = TextEditingController();
  RxString imageBase64 = ''.obs;


  @override
  void onInit() {
    super.onInit();
    // loadTheme();
    loadProfileData();
    loadSelectedProfileForEdit();
  }

  Future<void> pickImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || selectedProfileId.value.isEmpty) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    if (uid == null || profileId == null) return;

    final id = selectedProfileId.value;


    await database.child("users/$uid/profiles/$profileId").update({
      "imageBase64": base64Image,
    });

    // profileImageBase64.value = base64Image;
    //
    // profileImageBase64.value = base64Image;
      imageBase64.value = base64Image;
    profileImageBase64.value = base64Image;

    final index =
    profiles.indexWhere((p) => p["id"] == id);

    if (index != -1) {
      profiles[index]["imageBase64"] = base64Image;
      profiles.refresh();
    }
  }


  Future<void> saveTheme(bool isDark) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await database.child("users/$uid").update({"theme": isDark});

    themeMode.value = isDark;
  }

  Future<void> loadProfileData() async {
    if (uid == null) return;

    final snapshot = await database.child("users/$uid/profiles").get();

    profiles.clear();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final map = Map<String, dynamic>.from(value);
        map["id"] = key;
        profiles.add(map);
      });

    }
    if (profiles.isEmpty) {
      await createProfile("Main", "");
      return;
    }

    final savedId = storage.getSelectedProfile();


    if (savedId != null &&
        profiles.any((p) => p["id"] == savedId)) {
      selectedProfileId.value = savedId;
    }
    else {
      selectedProfileId.value = profiles.first["id"];
      storage.saveSelectedProfile(selectedProfileId.value);
    }
    await switchProfile(selectedProfileId.value);
  }

  Future<void> createProfile(String name, String imageBase64) async {
    if (uid == null) return;

    final newRef = database.child("users/$uid/profiles").push();

    final id = newRef.key!;

    await newRef.set({
      "id": id,
      "name": name,
      "imageBase64": imageBase64,
      "myList": [],
      "downloads": [],
    });

    await loadProfileData();
  }

  @override
  void onClose() {
    nameController.clear();
    imageBase64.value = "";
    super.onClose();
  }

  Future<void> switchProfile(String id) async {
    if (uid == null) return;

    selectedProfileId.value = id;
    storage.saveSelectedProfile(id);
    // if (id == selectedProfileId.value) return;

    // selectedProfileId.value = id;
    // storage.saveSelectedProfile(id);
    await database.child("users/$uid/selectedProfileId").set(id);

    final snapshot = await database.child("users/$uid/profiles/$id").get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      profileName.value = data["name"] ?? "Main";
      profileImageBase64.value = data["imageBase64"] ?? "";
      imageBase64.value = data["imageBase64"] ?? "";
    }

    await Get.find<DownloadController>()
        .loadDownloadsFromFirebase();

    await Get.find<MyListController>()
        .loadMyListFromFirebase();
  }


  Future<void> deleteProfile(String id) async {
    if (uid == null) return;

    if (profiles.length <= 1) {

      Get.snackbar(
        "Cannot Delete",
        "Last profile cannot be deleted. Logging out...",
        snackPosition: SnackPosition.BOTTOM,
      );

      await Future.delayed(Duration(seconds: 1));
      await _auth.signOut();
      storage.clearAll();
      storage.saveLoginStatus(false);
      SystemNavigator.pop();
      return;
    }

    // // ///  REMOVE LOCALLY FIRST (very important)
    // final updatedProfiles =
    // profiles.where((p) => p["id"] != id).toList();
    //
    // profiles.assignAll(updatedProfiles);
    //
    // /// FIX selectedProfileId safely
    // if (selectedProfileId.value == id) {
    //   selectedProfileId.value =
    //   updatedProfiles.first["id"];
    // }

      await database
          .child("users/$uid/profiles/$id")
          .remove();

      // if (selectedProfileId.value == id) {
      //   final remainingProfiles =
      //   profiles.where((p) => p["id"] != id).toList();
      //
      //   if (remainingProfiles.isNotEmpty) {
      //     final newId = remainingProfiles.first["id"];
      //     await switchProfile(newId);
      //     await Get.find<MyListController>().loadMyListFromFirebase();
      //     await Get.find<DownloadController>().loadDownloadsFromFirebase();
      //   }
      // }


    await loadProfileData();
  }

  Future<void> editProfile(String id, String name, String imageBase64) async {
    if (uid == null) return;

    await database.child("users/$uid/profiles/$id").update({
      "name": name,
      "imageBase64": imageBase64,
    });

    await loadProfileData();
  }

  Future<void> updateProfile() async {
    if (selectedProfileId.value.isEmpty) return;

    final id = selectedProfileId.value;
    final name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Error", "Profile name cannot be empty");
      return;
    }

    try {
      await database
          .child("users/$uid/profiles/$id")
          .update({
        "name": name,
        "imageBase64": imageBase64.value,
      });

      final index =
      profiles.indexWhere((p) => p["id"] == id);


      if (index != -1) {
        profiles[index]["name"] = name;
        profiles[index]["imageBase64"] =
            imageBase64.value;
        profiles.refresh();
      }

      profileName.value = name;
      profileImageBase64.value = imageBase64.value;

      await loadProfileData();
      await switchProfile(id);

      Get.back();

      Get.snackbar("Success", "Profile updated successfully");

      profiles.refresh();
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }
  }

  void logout() async {

    await _auth.signOut();
    storage.clearAll();
    storage.saveLoginStatus(false);
    Future.delayed(const Duration(milliseconds: 1), () {
      SystemNavigator.pop();
    });

  }

  void loadSelectedProfileForEdit() {
    final profile = profiles.firstWhereOrNull(
          (p) => p["id"] == selectedProfileId.value,
    );

    if (profile != null) {
      nameController.text = profile["name"] ?? "";
      imageBase64.value = profile["imageBase64"] ?? "";
    }
  }

}

