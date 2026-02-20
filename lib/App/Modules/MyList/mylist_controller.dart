import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Data/Models/comman_movie_model.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Services/storage_service.dart';

class MyListController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxList<MovieResults> myMovies = <MovieResults>[].obs;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get profileId => storage.selectedProfileId;
  RxList<MyMovie> myMovies1 = <MyMovie>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadMyListFromFirebase();
  }

  Future<void> loadMyListFromFirebase() async {
    if (uid == null || profileId == null) return;

    final snapshot = await database
        .child("users/$uid/profiles/$profileId/myList")
        .get();

    if (!snapshot.exists) {
      myMovies.clear();
      return;
    }

    final value = snapshot.value;

    if (value is Map) {
      myMovies.assignAll(
        value.values
            .whereType<Map>()
            .map((e) =>
            MovieResults.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    } else {
      debugPrint(
          "myList is not Map. It is ${value.runtimeType}");
    }
  }



  void addMovie(MovieResults movie) {
    if (uid == null || profileId == null) return;

    final ref = database.child(
        "users/$uid/profiles/$profileId/myList/${movie.id}");

    if (isAdded(movie)) {
      myMovies.removeWhere((m) => m.id == movie.id);
      ref.remove();
    } else {
      myMovies.add(movie);
      ref.set(movie.toJson());
    }
  }

  void addMyMovie(MyMovie movie) {
    if (uid == null || profileId == null) return;

    final ref = database.child(
        "users/$uid/profiles/$profileId/myList/${movie.id}");

    if (isAdded1(movie)) {
      myMovies1.removeWhere((m) => m.id == movie.id);
      ref.remove();
    } else {
      myMovies1.add(movie);
      ref.set(movie.toJson());
    }
  }


  bool isAdded1(MyMovie movie) {
    return myMovies1.any((m) => m.id == movie.id);
  }

  bool isAdded(MovieResults movie) {
    return myMovies.any((m) => m.id == movie.id);
  }

  void saveToFirebase() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    database.child("users/$uid/profiles/$profileId/myList").set(
      myMovies.map((e) => e.toJson()).toList(),
    );
  }

}
