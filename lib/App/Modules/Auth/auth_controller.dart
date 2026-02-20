import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/storage_service.dart';
import '../../Routes/app_pages.dart';
import '../Profile/profile_controller.dart';
import '../Theme/theme.controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  // final box = GetStorage();
  final storage = Get.find<StorageService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final database = FirebaseDatabase.instance.ref();


  // LOGIN
  Future<void> login() async {
    try {
      isLoading.value = true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final ProfileController profileController = Get.find<ProfileController>();

      await profileController.loadProfileData();

      if (profileController.profiles.isEmpty) {
        await profileController.createProfile("Main", "");
        await profileController.loadProfileData();
      }

      if (profileController.profiles.length == 1) {
        final id = profileController.profiles.first["id"];
        await profileController.switchProfile(id);
        Get.offAllNamed(AppRoutes.bottomAppBar);
      } else {
        Get.offAllNamed(AppRoutes.profileSelection);
      }

      storage.saveLoginStatus(true);
      storage.saveUserEmail(_auth.currentUser!.email!);
      await Get.find<ThemeController>().reloadThemeAfterLogin();



      if (profileController.profiles.length == 1) {
      Get.toNamed(AppRoutes.bottomAppBar);

      }
      // storage.saveLoginStatus( true);
      await createUserInDatabase(_auth.currentUser!);

    } on FirebaseAuthException catch (e) {
      Get.snackbar(logInFailed, e.message ?? error,
          backgroundColor: whiteColor,
          colorText: blackColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    try {
      isLoading.value = true;

      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      storage.saveLoginStatus(true);
      storage.saveUserEmail(_auth.currentUser!.email!);

      final ProfileController profileController =
      Get.find<ProfileController>();


      await profileController.loadProfileData();

      if (profileController.profiles.isEmpty) {
        await profileController.createProfile("Main", "");
        await profileController.loadProfileData();
      }

      if (profileController.profiles.length == 1) {
        final id = profileController.profiles.first["id"];
        await profileController.switchProfile(id);
        Get.offAllNamed(AppRoutes.bottomAppBar);
      } else {
        Get.offAllNamed(AppRoutes.profileSelection);
      }

      await createUserInDatabase(_auth.currentUser!);

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        signUpFailed,
        e.message ?? error,
        backgroundColor: whiteColor,
        colorText: blackColor,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = _auth.currentUser!;


      await createUserInDatabase(user);


      storage.saveLoginStatus(true);
      storage.saveUserEmail(user.email ?? "");


      await Get.find<ThemeController>().reloadThemeAfterLogin();


      final ProfileController profileController =
      Get.find<ProfileController>();

      await profileController.loadProfileData();

      if (profileController.profiles.isEmpty) {
        await profileController.createProfile("Main", "");
        await profileController.loadProfileData();
      }

      if (profileController.profiles.length == 1) {
        final id = profileController.profiles.first["id"];
        await profileController.switchProfile(id);
        Get.toNamed(AppRoutes.bottomAppBar);
      } else {
        Get.toNamed(AppRoutes.profileSelection);
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        googleSignInFailed,
        e.message ?? error,
        backgroundColor: whiteColor,
        colorText: blackColor,
      );
    } catch (e) {
      Get.snackbar(
        error,
        e.toString(),
        backgroundColor: whiteColor,
        colorText: blackColor,
      );
    } finally {
      isLoading.value = false;
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

  Future<void> createUserInDatabase(User user) async {
    final uid = user.uid;
    final userRef = database.child("users/$uid");

    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final profileId = database.child("temp").push().key;

      await userRef.set({
        "email": user.email,
        "theme": storage.isDarkMode,
        "profiles": {
          profileId: {
            "id": profileId,
            "name": "Main",
            "imageBase64": "",
            "isKids": false,
            "myList": {},
            "downloads": {}
          }
        }
      });
    }
  }
  }

