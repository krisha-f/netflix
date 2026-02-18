// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_navigation/src/snackbar/snackbar.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
//
// import '../../Data/Models/movie_model.dart' as movie;
//
// class DownloadController extends GetxController {
//   RxList<movie.Results> downloadedMovies = <movie.Results>[].obs;
//   RxBool isDownloading = false.obs;
//   RxInt downloadingMovieId = (-1).obs;
//
//   Future<void> downloadMovie(movie.Results movie) async {
//     if (isDownloading.value) return;
//
//     isDownloading.value = true;
//     downloadingMovieId.value = movie.id ?? -1;
//
//     addDownloadMovie(movie);
//
//     isDownloading.value = false;
//     downloadingMovieId.value = -1;
//
//     Get.snackbar(
//       "Download Complete",
//       "${movie.title} saved offline",
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.black,
//       colorText: Colors.white,
//       duration: Duration(seconds: 2),
//     );
//   }
//
//   // void addDownloadMovie(Results movie) {
//   //   if (isDownloaded(movie)) {
//   //     downloadedMovies.add(movie);
//   //     // downloadedMovies.removeWhere((m) => m.id == movie.id);
//   //   } else {
//   //     downloadedMovies.removeWhere((m) => m.id == movie.id);
//   //     // downloadedMovies.add(movie);
//   //   }
//   // }
//
//   void addDownloadMovie(movie.Results movie) {
//     if (!isDownloaded(movie)) {
//       downloadedMovies.add(movie);
//     } else {
//       downloadedMovies.removeWhere((m) => m.id == movie.id);
//     }
//   }
//
//   bool isDownloaded(movie.Results movie) {
//     return downloadedMovies.any((m) => m.id == movie.id);
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Data/Models/movie_model.dart' as movie;
import '../../Data/Services/storage_service.dart';

class DownloadController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxList<movie.Results> downloadedMovies = <movie.Results>[].obs;
  RxBool isDownloading = false.obs;
  RxInt downloadingMovieId = (-1).obs;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get profileId => storage.selectedProfileId;
  // final uid = FirebaseAuth.instance.currentUser!.uid;


  @override
  void onInit() {
    super.onInit();
    loadDownloadsFromFirebase();
  }

  Future<void> downloadMovie(movie.Results movieData) async {
    if (isDownloading.value) return;

    isDownloading.value = true;
    downloadingMovieId.value = movieData.id ?? -1;

    addDownloadMovie(movieData);

    isDownloading.value = false;
    downloadingMovieId.value = -1;

    Get.snackbar(
      "Download Complete",
      "${movieData.title} saved offline",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // void addDownloadMovie(movie.Results movieData) {
  //   // final email = storage.userEmail;
  //   if (uid == null) return;
  //
  //   debugPrint("********************");
  //   // debugPrint(email);
  //   debugPrint("********************");
  //
  //   // if (email == null) return;
  //
  //   if (!isDownloaded(movieData)) {
  //     downloadedMovies.add(movieData);
  //
  //     // 🔥 Save in Firebase using movieId as key
  //     // database
  //     //     .child("users/$email/downloads/${movieData.id}")
  //     //     .set(movieData.toJson());
  //
  //     database.child("users/$uid/downloads/${movieData.id}").set(movieData.toJson());
  //
  //   } else {
  //     downloadedMovies.removeWhere((m) => m.id == movieData.id);
  //
  //     database
  //         .child("users/$uid/downloads/${movieData.id}")
  //         .remove();
  //   }
  // }

  // void addDownloadMovie(movie.Results movieData) {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   if (!isDownloaded(movieData)) {
  //     downloadedMovies.add(movieData);
  //
  //     database
  //         .child("users/$uid/downloads/${movieData.id}")
  //         .set(movieData.toJson());
  //   } else {
  //     downloadedMovies.removeWhere((m) => m.id == movieData.id);
  //
  //     database
  //         .child("users/$uid/downloads/${movieData.id}")
  //         .remove();
  //   }
  // }


  void addDownloadMovie(movie.Results movieData) {
    if (uid == null || profileId == null) return;

    final ref = database.child(
        "users/$uid/profiles/$profileId/downloads/${movieData.id}");

    if (!isDownloaded(movieData)) {
      downloadedMovies.add(movieData);
      ref.set(movieData.toJson());
    } else {
      downloadedMovies.removeWhere((m) => m.id == movieData.id);
      ref.remove();
    }
  }
  bool isDownloaded(movie.Results movieData) {
    return downloadedMovies.any((m) => m.id == movieData.id);
  }

  // Future<void> loadDownloadsFromFirebase() async {
  //   final email = storage.userEmail;
  //   if (email == null) return;
  //
  //   final snapshot =
  //   await database.child("users/$email/downloads").get();
  //
  //   if (snapshot.exists) {
  //     final data = Map<String, dynamic>.from(snapshot.value as Map);
  //
  //     downloadedMovies.assignAll(
  //       data.values
  //           .map((e) =>
  //           movie.Results.fromJson(Map<String, dynamic>.from(e)))
  //           .toList(),
  //     );
  //   }
  // }

  // Future<void> loadDownloadsFromFirebase() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   // final email = storage.userEmail;
  //   // if (email == null) return;
  //
  //   final snapshot =
  //   await database.child("users/$uid/downloads").get();
  //
  //   if (!snapshot.exists) return;
  //
  //   final value = snapshot.value;
  //
  //   if (value is Map) {
  //     final data = Map<String, dynamic>.from(value);
  //
  //     downloadedMovies.assignAll(
  //       data.values.map((e) {
  //         if (e is Map) {
  //           return movie.Results.fromJson(
  //               Map<String, dynamic>.from(e));
  //         }
  //         return null;
  //       }).whereType<movie.Results>().toList(),
  //     );
  //   } else {
  //     print("Downloads is not a Map. It is ${value.runtimeType}");
  //   }
  // }

  // Future<void> loadDownloadsFromFirebase() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   final snapshot =
  //   await database.child("users/$uid/downloads").get();
  //
  //   if (!snapshot.exists) return;
  //
  //   final value = snapshot.value;
  //
  //   if (value is Map) {
  //     final data = Map<String, dynamic>.from(value);
  //
  //     downloadedMovies.assignAll(
  //       data.values
  //           .whereType<Map>()
  //           .map((e) => movie.Results.fromJson(
  //           Map<String, dynamic>.from(e)))
  //           .toList(),
  //     );
  //   }
  // }

  Future<void> loadDownloadsFromFirebase() async {
    if (uid == null || profileId == null) return;
    downloadedMovies.clear();
    final snapshot = await database
        .child("users/$uid/profiles/$profileId/downloads")
        .get();

    if (!snapshot.exists) return;

    final value = snapshot.value;

    if (value is Map) {
      downloadedMovies.assignAll(
        value.values
            .whereType<Map>()
            .map((e) => movie.Results.fromJson(
            Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
  }
}

