import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Data/Services/storage_service.dart';
import '../../Routes/app_pages.dart';
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
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // storage.saveLoginStatus( true);
      await createUserInDatabase(_auth.currentUser!);

      storage.saveLoginStatus(true);
      storage.saveUserEmail(_auth.currentUser!.email!);
      await Get.find<ThemeController>().reloadThemeAfterLogin();

      Get.offAllNamed(AppRoutes.bottomAppBar);
      // storage.saveUserEmail(_auth.currentUser?.email ?? '');




      // Get.offAllNamed(AppRoutes.bottomAppBar);

    } on FirebaseAuthException catch (e) {
      Get.snackbar(logInFailed, e.message ?? error,
          backgroundColor: whiteColor,
          colorText: blackColor);
    } finally {
      isLoading.value = false;
    }
  }

  // SIGNUP
  Future<void> signup() async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // storage.saveLoginStatus(true);
      // storage.saveUserEmail( _auth.currentUser?.email?? '');
      //
      // Get.offAllNamed(AppRoutes.bottomAppBar);
      await createUserInDatabase(_auth.currentUser!);

      storage.saveLoginStatus(true);
      storage.saveUserEmail(_auth.currentUser!.email!);

      Get.offAllNamed(AppRoutes.bottomAppBar);

    } on FirebaseAuthException catch (e) {
      Get.snackbar(signUpFailed, e.message ?? error,
          backgroundColor: whiteColor,
          colorText: blackColor);
    } finally {
      isLoading.value = false;
    }
  }

  //sign in with google (not connected getstorage)
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

      Get.offAllNamed(AppRoutes.bottomAppBar);

    } on FirebaseAuthException catch (e) {
      Get.snackbar(googleSignInFailed, e.message ?? error);
    } catch (e) {
      Get.snackbar(error, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    // storage.saveLoginStatus(true);
    await _auth.signOut();
    // storage.clearAll();
    // storage.saveLoginStatus(true);
    storage.saveLoginStatus(false);
    storage.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> createUserInDatabase(User user) async {
    final uid = user.uid;

    final userRef = database.child("users/$uid");

    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        "email": user.email,
        "theme": false,
        "profile": {
          "imageBase64": ""
        },
        "myList": [],
        "download":[]
      });
    }
  }



}