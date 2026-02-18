import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/Services/storage_service.dart';
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

  @override
  void onInit() {
    super.onInit();
    // loadTheme();
    loadProfileData();
  }

  Future<void> pickImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    // Convert image to Base64
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Save in Realtime Database
    await database.child("users/$uid/profile").update({
      "imageBase64": base64Image,
    });

    profileImageBase64.value = base64Image;
  }

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

    await database.child("users/$uid").update({
      "theme": isDark,
    });

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

  Future<void> loadProfileData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await database.child("users/$uid").get();

    if (!snapshot.exists) return;

    final data = snapshot.value;

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      userEmail.value = map["email"] ?? "";

      themeMode.value = map["theme"] ?? "light";

      if (map["profile"] != null &&
          map["profile"]["imageBase64"] != null) {
        profileImageBase64.value =
        map["profile"]["imageBase64"];
      }
    }
  }
}



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