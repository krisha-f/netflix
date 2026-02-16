
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/Services/storage_service.dart';
import '../MyList/mylist_controller.dart';
import '../Theme/theme.controller.dart';

class ProfileController extends GetxController{
  final themeController = Get.find<ThemeController>();
  final myListController = Get.find<MyListController>();
  // final authController = Get.find<AuthController>();
  // final box = GetStorage();
  final storage = Get.find<StorageService>();

  final ImagePicker _picker = ImagePicker();
  RxString profileImagePath = ''.obs;
  // Future<void> pickImage() async {
  //   final email = storage.userEmail;
  //   if (email == null) return;
  //
  //   final XFile? image =
  //   await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image != null) {
  //     profileImagePath.value = image.path;
  //     storage.saveProfileImage(email, image.path);
  //   }
  // }

  final database = FirebaseDatabase.instance.ref();
  final storageFirebase = FirebaseStorage.instance;

  // final user = FirebaseAuth.instance.currentUser;
  // late final uid = user!.uid;

  @override
  void onInit(){
    super.onInit();
    loadProfileImage();
  }


  Future<void> pickImage() async {
    final email = storage.userEmail;
    if (email == null) return;

    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    profileImagePath.value = image.path;

    File file = File(image.path);

    // 🔥 Upload to Firebase Storage
    final ref = storageFirebase
        .ref()
        .child("profile_images")
        .child("$email.jpg");

    await ref.putFile(file);

    // final downloadUrl = await ref.getDownloadURL();
    //
    // // 🔥 Save URL in Realtime DB
    // await database
    //     .child("users/$email/profile/imageUrl")
    //     .set(downloadUrl);

    // 🔥 Save local path also
    storage.saveProfileImage(email, image.path);
  }

  Future<void> loadProfileImage() async {
    final email = storage.userEmail;
    if (email == null) return;

    final snapshot =
    await database.child("users/$email/profile/imageUrl").get();

    if (snapshot.exists) {
      profileImagePath.value = snapshot.value.toString();
    }
  }

}