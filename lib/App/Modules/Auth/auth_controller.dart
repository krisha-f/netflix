import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netflix/Constant/app_colors.dart';
import '../../../Constant/app_strings.dart';
import '../../Routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  final box = GetStorage();
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

      box.write(isLogIn, true);
      box.write('userEmail', _auth.currentUser?.email);

      Get.offAllNamed(AppRoutes.bottomAppBar);

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

      box.write(isLogIn, true);
      box.write('userEmail', _auth.currentUser?.email);

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
          googleUser.authentication;

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
    await _auth.signOut();
    box.erase();
    box.write(isLogIn, false);
    Get.offAllNamed(AppRoutes.login);
  }
}