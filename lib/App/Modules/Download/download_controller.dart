
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Data/Models/movie_model.dart' ;
import '../../Data/Services/storage_service.dart';

class DownloadController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxList<MovieResults> downloadedMovies = <MovieResults>[].obs;

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

  Future<void> downloadMovie(MovieResults movieData) async {
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


  void addDownloadMovie(MovieResults movieData) {
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
  bool isDownloaded(MovieResults movieData) {
    return downloadedMovies.any((m) => m.id == movieData.id);
  }

  bool isMovieDownloadedById(int? movieId) {
    if (movieId == null) return false;
    return downloadedMovies.any((m) => m.id == movieId);
  }

  Future<void> downloadMovieById({
    required int? movieId,
    required String? movieTitle,
    required Map<String, dynamic> movieJson,
  }) async {
    if (movieId == null) return;
    if (uid == null || profileId == null) return;

    if (downloadingMovieId.value == movieId) return;

    downloadingMovieId.value = movieId;

    final ref = database.child(
      "users/$uid/profiles/$profileId/downloads/$movieId",
    );

    try {
      final alreadyDownloaded =
      downloadedMovies.any((m) => m.id == movieId);

      if (alreadyDownloaded) {
        downloadedMovies.removeWhere((m) => m.id == movieId);
        await ref.remove();
      } else {
        downloadedMovies.add(
          MovieResults.fromJson(movieJson),
        );

        await ref.set(movieJson);

        Get.snackbar(
          "Download Complete",
          "$movieTitle saved offline",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }

    downloadingMovieId.value = -1;
  }


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
            .map((e) => MovieResults.fromJson(
            Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
  }
}

