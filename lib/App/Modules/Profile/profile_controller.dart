import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netflix/App/Routes/app_pages.dart';

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
  }

  Future<void> pickImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    // Convert image to Base64
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Save in Realtime Database
    // await database.child("users/$uid/profile").update({
    //   "imageBase64": base64Image,
    // });
    if (uid == null || profileId == null) return;

    await database.child("users/$uid/profiles/$profileId").update({
      "imageBase64": base64Image,
    });

    profileImageBase64.value = base64Image;

    profileImageBase64.value = base64Image;
  }

  // Future<void> pickImageForCreateProfile() async {
  //   final XFile? image =
  //   await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image == null) return;
  //
  //   final bytes = await File(image.path).readAsBytes();
  //   tempImageBase64.value = base64Encode(bytes);
  // }

  // Future<void> saveTheme(String theme) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   await database.child("users/$uid").update({
  //     "theme": theme,
  //   });
  //
  //   themeMode.value = theme;
  // }

  Future<void> saveTheme(bool isDark) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await database.child("users/$uid").update({"theme": isDark});

    themeMode.value = isDark;
  }

  // void toggleTheme() {
  //   final newValue = !themeMode.value;
  //   saveTheme(newValue);
  // }

  // Future<void> loadTheme() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   final snapshot =
  //   await database.child("users/$uid/theme").get();
  //
  //   if (snapshot.exists) {
  //     themeMode.value = snapshot.value as bool;
  //   }
  // }

  // Future<void> loadProfileData() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   final snapshot = await database.child("users/$uid").get();
  //
  //   if (!snapshot.exists) return;
  //
  //   final data = snapshot.value;
  //
  //   if (data is Map) {
  //     final map = Map<String, dynamic>.from(data);
  //
  //     // userEmail.value = map["email"] ?? "";
  //     //
  //     // themeMode.value = map["theme"] ?? "light";
  //     //
  //     // if (map["profile"] != null &&
  //     //     map["profile"]["imageBase64"] != null) {
  //     //   profileImageBase64.value =
  //     //   map["profile"]["imageBase64"];
  //     // }
  //
  //     if (data is Map) {
  //       final map = Map<String, dynamic>.from(data);
  //
  //       profileImageBase64.value =
  //           map["imageBase64"] ?? "";
  //
  //       userEmail.value =
  //           FirebaseAuth.instance.currentUser?.email ?? "";
  //     }
  //
  //   }
  // }

  // Future<void> createProfile(String name, String avatar) async {
  //   if (uid == null) return;
  //
  //   final newRef =
  //   database.child("users/$uid/profiles").push();
  //
  //   await newRef.set({
  //     "name": name,
  //     "avatar": avatar,
  //     "myList": [],
  //     "downloads": [],
  //   });
  //
  //   await loadProfileData();
  // }
  //
  // Future<void> deleteProfile(String profileId) async {
  //   if (uid == null) return;
  //
  //   await database
  //       .child("users/$uid/profiles/$profileId")
  //       .remove();
  //
  //   await loadProfileData();
  // }
  //
  // void switchProfile(String profileId) {
  //   storage.saveSelectedProfile(profileId);
  //   Get.toNamed(AppRoutes.home);
  // }

  // ✅ LOAD ALL PROFILES
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
    storage.saveSelectedProfile(profiles.last["id"]);
    final savedId = storage.getSelectedProfile();

    if (savedId != null &&
        profiles.any((p) => p["id"] == savedId)) {
      selectedProfileId.value = savedId;
    } else if (profiles.length == 1) {
      //  If only 1 profile → auto select
      final onlyId = profiles.first["id"];
      selectedProfileId.value = onlyId;
      storage.saveSelectedProfile(onlyId);
    } else {
      selectedProfileId.value = "";
    }

    // If no profile → create default Main
    if (profiles.isEmpty) {
      await createProfile("Main", "");
    }

    // Auto select first if none selected
    if (selectedProfileId.value.isEmpty) {
      selectedProfileId.value = profiles.first["id"];
      await switchProfile(selectedProfileId.value);
    }
  }

  // CREATE PROFILE
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

  // SWITCH PROFILE
  Future<void> switchProfile(String id) async {
    if (uid == null) return;
    if (id == selectedProfileId.value) return;

    selectedProfileId.value = id;
    storage.saveSelectedProfile(id);
    await database.child("users/$uid/selectedProfileId").set(id);

    final snapshot = await database.child("users/$uid/profiles/$id").get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      profileName.value = data["name"] ?? "Main";
      profileImageBase64.value = data["imageBase64"] ?? "";
    }

    //  RELOAD DATA FOR NEW PROFILE
    await Get.find<DownloadController>()
        .loadDownloadsFromFirebase();

    await Get.find<MyListController>()
        .loadMyListFromFirebase();
  }

  // ✅ DELETE PROFILE
  // Future<void> deleteProfile(String id) async {
  //   if (uid == null) return;
  //
  //   await database.child("users/$uid/profiles/$id").remove();
  //
  //   await loadProfileData();
  // }

  Future<void> deleteProfile(String id) async {
    if (uid == null) return;

    //  If only 1 profile exists
    if (profiles.length <= 1) {

      Get.snackbar(
        "Cannot Delete",
        "Last profile cannot be deleted. Logging out...",
        snackPosition: SnackPosition.BOTTOM,
      );

      await Future.delayed(Duration(seconds: 1));
      await _auth.signOut();
      // storage.clearAll();
      // storage.saveLoginStatus(true);
      storage.clearAll();
      storage.saveLoginStatus(false);
      SystemNavigator.pop();
      // storage.clearAll();
      // Get.toNamed(AppRoutes.login);
      // await FirebaseAuth.instance.signOut();
      //
      // Get.toNamed(AppRoutes.login);

      return;
    }


      // Delete normally if more than 1
      await database
          .child("users/$uid/profiles/$id")
          .remove();

      // If deleted profile was selected → switch to first
      if (selectedProfileId.value == id) {
        final remainingProfiles =
        profiles.where((p) => p["id"] != id).toList();

        if (remainingProfiles.isNotEmpty) {
          // await switchProfile(remainingProfiles.first["id"]);
          final newId = remainingProfiles.first["id"];
          await switchProfile(newId);
          await Get.find<MyListController>().loadMyListFromFirebase();
          await Get.find<DownloadController>().loadDownloadsFromFirebase();
        }
      }


    await loadProfileData();
  }

  // EDIT PROFILE
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
        "image": imageBase64.value,
      });

      await loadProfileData();
      Get.back();

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }
  }

  // /// PICK IMAGE
  // Future<void> pickImage() async {
  // final XFile? image =
  // await _picker.pickImage(source: ImageSource.gallery);
  //
  // if (image == null) return;
  //
  // final bytes = await File(image.path).readAsBytes();
  // imageBase64.value = base64Encode(bytes);
  // }

  /// UPDATE PROFILE
  // Future<void> updateProfile() async {
  // if (uid == null) return;
  //
  // await database
  //     .child("users/$uid/profiles/$profileId")
  //     .update({
  // "name": nameController.text.trim(),
  // "imageBase64": imageBase64.value,
  // });
  //
  // /// Reload main controller
  // await Get.find<ProfileController>()
  //     .loadProfileData();
  //
  // Get.back();
  // }








}


//pending :

// edit get problem
//also ui



//not delete all profile 1 still then if this 1 deleted then snackbar popup give logout plz
//when 1 profile then consider this current profile logic
//when craete profile so current profile is consider new profile
//edit
//current profile store in firebase
//add profile ui update
//main profile screen update

//update login signup for new screen



// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../Data/Services/storage_service.dart';
// import '../MyList/mylist_controller.dart';
// import '../Theme/theme.controller.dart';
//
// class ProfileController extends GetxController {
//   final themeController = Get.find<ThemeController>();
//   final myListController = Get.find<MyListController>();
//   final storage = Get.find<StorageService>();
//
//   final ImagePicker _picker = ImagePicker();
//
//   RxString profileImagePath = ''.obs;
//
//   final database = FirebaseDatabase.instance.ref();
//   final storageFirebase = FirebaseStorage.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProfileImage();
//   }
//
//   Future<void> pickImage() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     final XFile? image =
//     await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image == null) return;
//
//     File file = File(image.path);
//
//     // Upload to Firebase Storage
//     final ref = storageFirebase
//         .ref()
//         .child("profile_images")
//         .child("$uid.jpg");
//
//     await ref.putFile(file);
//
//     final downloadUrl = await ref.getDownloadURL();
//
//     // Save URL in Realtime Database
//     await database
//         .child("users/$uid/profile/imageUrl")
//         .set(downloadUrl);
//
//     profileImagePath.value = downloadUrl;
//   }
//
//   Future<void> loadProfileImage() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//
//     final snapshot =
//     await database.child("users/$uid/profile/imageUrl").get();
//
//     if (!snapshot.exists) return;
//
//     final value = snapshot.value;
//
//     if (value is String) {
//       profileImagePath.value = value;
//     }
//   }
// }

//
// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../Data/Services/storage_service.dart';
// import '../MyList/mylist_controller.dart';
// import '../Theme/theme.controller.dart';
//
// class ProfileController extends GetxController{
//   final themeController = Get.find<ThemeController>();
//   final myListController = Get.find<MyListController>();
//   // final authController = Get.find<AuthController>();
//   // final box = GetStorage();
//   final storage = Get.find<StorageService>();
//
//   final ImagePicker _picker = ImagePicker();
//   RxString profileImagePath = ''.obs;
//   // Future<void> pickImage() async {
//   //   final email = storage.userEmail;
//   //   if (email == null) return;
//   //
//   //   final XFile? image =
//   //   await _picker.pickImage(source: ImageSource.gallery);
//   //
//   //   if (image != null) {
//   //     profileImagePath.value = image.path;
//   //     storage.saveProfileImage(email, image.path);
//   //   }
//   // }
//
//   final database = FirebaseDatabase.instance.ref();
//   final storageFirebase = FirebaseStorage.instance;
//
//   // final user = FirebaseAuth.instance.currentUser;
//   // late final uid = user!.uid;
//
//   @override
//   void onInit(){
//     super.onInit();
//     loadProfileImage();
//   }
//
//
//   Future<void> pickImage() async {
//     final email = storage.userEmail;
//     if (email == null) return;
//
//     final XFile? image =
//     await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image == null) return;
//
//     profileImagePath.value = image.path;
//
//     File file = File(image.path);
//
//     // 🔥 Upload to Firebase Storage
//     final ref = storageFirebase
//         .ref()
//         .child("profile_images")
//         .child("$email.jpg");
//
//     await ref.putFile(file);
//
//     // final downloadUrl = await ref.getDownloadURL();
//     //
//     // // 🔥 Save URL in Realtime DB
//     // await database
//     //     .child("users/$email/profile/imageUrl")
//     //     .set(downloadUrl);
//
//     // 🔥 Save local path also
//     storage.saveProfileImage(email, image.path);
//   }
//
//   Future<void> loadProfileImage() async {
//     final email = storage.userEmail;
//     if (email == null) return;
//
//     final snapshot =
//     await database.child("users/$email/profile/imageUrl").get();
//
//     if (snapshot.exists) {
//       profileImagePath.value = snapshot.value.toString();
//     }
//   }
//
// }
