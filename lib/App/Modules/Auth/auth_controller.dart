import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
      // await _auth.signInWithEmailAndPassword(
      //   email: emailController.text.trim(),
      //   password: passwordController.text.trim(),
      // );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        // email: email.trim(),
        // password: password.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // final profileController = Get.put(ProfileController());
      final ProfileController profileController = Get.find<ProfileController>();

      await profileController.loadProfileData();

      if (profileController.profiles.isEmpty) {
        await profileController.createProfile("Main", "avatar1");
        await profileController.loadProfileData();
      }

      if (profileController.profiles.length == 1) {
        final id = profileController.profiles.first["id"];
        profileController.switchProfile(id);
        // Get.toNamed(AppRoutes.bottomAppBar);
      } else {
        Get.toNamed(AppRoutes.profileSelection);
      }

      // // storage.saveLoginStatus( true);
      // await createUserInDatabase(_auth.currentUser!);

      storage.saveLoginStatus(true);
      storage.saveUserEmail(_auth.currentUser!.email!);
      await Get.find<ThemeController>().reloadThemeAfterLogin();

      // Get.offAllNamed(AppRoutes.bottomAppBar);
      // Get.offAllNamed(AppRoutes.profileSelection);
      // storage.saveUserEmail(_auth.currentUser?.email ?? '');



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

  // SIGNUP
  // Future<void> signup() async {
  //   try {
  //     isLoading.value = true;
  //     await _auth.createUserWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //
  //     // storage.saveLoginStatus(true);
  //     // storage.saveUserEmail( _auth.currentUser?.email?? '');
  //     //
  //     // Get.offAllNamed(AppRoutes.bottomAppBar);
  //     await createUserInDatabase(_auth.currentUser!);
  //
  //     storage.saveLoginStatus(true);
  //     storage.saveUserEmail(_auth.currentUser!.email!);
  //
  //     // Get.offAllNamed(AppRoutes.bottomAppBar);
  //     Get.toNamed(AppRoutes.profileSelection);
  //
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar(signUpFailed, e.message ?? error,
  //         backgroundColor: whiteColor,
  //         colorText: blackColor);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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

      //  Load profiles
      await profileController.loadProfileData();

      //  If no profile → create default
      if (profileController.profiles.isEmpty) {
        await profileController.createProfile("Main", "");
        await profileController.loadProfileData();
      }

      //  If only one profile → auto select & go bottom
      if (profileController.profiles.length == 1) {
        final id = profileController.profiles.first["id"];
        await profileController.switchProfile(id);
        Get.toNamed(AppRoutes.bottomAppBar);
      } else {
        //  Multiple profiles → show selection
        Get.toNamed(AppRoutes.profileSelection);
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

  //sign in with google (not connected getstorage)
  // Future<void> signInWithGoogle() async {
  //   try {
  //     isLoading.value = true;
  //
  //     final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  //
  //     await googleSignIn.initialize();
  //
  //     final GoogleSignInAccount googleUser =
  //     await googleSignIn.authenticate();
  //
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     // Get.offAllNamed(AppRoutes.profileSelection);
  //     Get.toNamed(AppRoutes.bottomAppBar);
  //
  //   } on FirebaseAuthException catch (e) {
  //     Get.snackbar(googleSignInFailed, e.message ?? error);
  //   } catch (e) {
  //     Get.snackbar(error, e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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

      //  Create user in Realtime Database if not exists
      await createUserInDatabase(user);

      //  Save login status in GetStorage
      storage.saveLoginStatus(true);
      storage.saveUserEmail(user.email ?? "");

      // Reload theme
      await Get.find<ThemeController>().reloadThemeAfterLogin();

      //  Handle Profiles (same as login)
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
    // storage.saveLoginStatus(true);
    await _auth.signOut();
    // storage.clearAll();
    // storage.saveLoginStatus(true);
    storage.clearAll();
    storage.saveLoginStatus(false);
    // storage.clearAll();
    // Get.toNamed(AppRoutes.login);
    // SystemNavigator.pop();
    Future.delayed(const Duration(milliseconds: 1), () {
      SystemNavigator.pop();
    });

  }

  // Future<void> createUserInDatabase(User user) async {
  //   final uid = user.uid;
  //
  //   final userRef = database.child("users/$uid");
  //
  //   final snapshot = await userRef.get();
  //
  //   if (!snapshot.exists) {
  //     await userRef.set({
  //       "email": user.email,
  //       "theme": false,
  //       "profile": {
  //         "imageBase64": ""
  //       },
  //       "myList": [],
  //       "download":[]
  //     });
  //   }
  // }

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

