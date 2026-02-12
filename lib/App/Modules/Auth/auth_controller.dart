import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netflix/Constant/app_colors.dart';

import '../../Routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // LOGIN
  Future<void> login() async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(AppRoutes.bottomAppBar);
      // Get.offAllNamed('/bottomAppBar');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Error",backgroundColor: whiteColor,colorText: blackColor);
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
      Get.offAllNamed(AppRoutes.bottomAppBar);

      // Get.offAllNamed('/bottomAppBar');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Error",backgroundColor: whiteColor,colorText: blackColor);
    } finally {
      isLoading.value = false;
    }
  }

  //sign in with google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Get.offAllNamed(AppRoutes.bottomAppBar);

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Google Sign-In Failed", e.message ?? "Error");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}