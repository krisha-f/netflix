import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Services/storage_service.dart';

class MyListController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxList<MovieResults> myMovies = <MovieResults>[].obs;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get profileId => storage.selectedProfileId;

  // String? get profileId =>
  //     Get.find<StorageService>().selectedProfileId;


  @override
  void onInit() {
    super.onInit();
    loadMyListFromFirebase();
    // loadLocalData();
    // syncWithFirebase();
  }

  // void loadLocalData() {
  //   final data = storage.getMyList();
  //
  //   myMovies.assignAll(
  //     data
  //         .whereType<Map>()
  //         .map((e) =>
  //         Results.fromJson(Map<String, dynamic>.from(e)))
  //         .toList(),
  //   );
  // }

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

  // void addMovie(Results movie) {
  //   if (isAdded(movie)) {
  //     myMovies.removeWhere((m) => m.id == movie.id);
  //   } else {
  //     myMovies.add(movie);
  //   }
  //
  //   storage.saveMyList(
  //       myMovies.map((e) => e.toJson()).toList());
  //
  //   saveToFirebase();
  // }


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

  // Future<void> syncWithFirebase() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;
  //
  //   final snapshot =
  //   await database.child("users/$uid/myList").get();
  //
  //   if (!snapshot.exists) return;
  //
  //   final value = snapshot.value;
  //
  //   if (value is List) {
  //     final safeList = value
  //         .whereType<Map>()
  //         .map((e) =>
  //         Results.fromJson(Map<String, dynamic>.from(e)))
  //         .toList();
  //
  //     myMovies.assignAll(safeList);
  //
  //     storage.saveMyList(
  //         safeList.map((e) => e.toJson()).toList());
  //   } else {
  //     debugPrint(
  //         "myList is not a List. It is ${value.runtimeType}");
  //   }
  // }
}


// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../Data/Models/movie_model.dart';
// import '../../Data/Services/storage_service.dart';
//
// class MyListController extends GetxController {
//   final storage = Get.find<StorageService>();
//   final database = FirebaseDatabase.instance.ref();
//
//   RxList<Results> myMovies = <Results>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadLocalData();
//     syncWithFirebase();
//   }
//
//   void loadLocalData() {
//     final data = storage.getMyList();
//     myMovies.assignAll(
//       data.map((e) => Results.fromJson(Map<String, dynamic>.from(e))).toList(),
//     );
//   }
//
//   void addMovie(Results movie) {
//     if (isAdded(movie)) {
//       myMovies.removeWhere((m) => m.id == movie.id);
//     } else {
//       myMovies.add(movie);
//     }
//
//     storage.saveMyList(myMovies.map((e) => e.toJson()).toList());
//     saveToFirebase();
//   }
//
//   bool isAdded(Results movie) {
//     return myMovies.any((m) => m.id == movie.id);
//   }
//
//   void saveToFirebase() {
//     final email = storage.userEmail;
//
//     debugPrint("*********************");
//     debugPrint(email);
//     debugPrint("*********************");
//
//
//     if (email == null) return;
//
//
//
//     database.child("users/$email/myList").set(
//       myMovies.map((e) => e.toJson()).toList(),
//     );
//   }
//
//   void syncWithFirebase() async {
//     final email = storage.userEmail;
//     if (email == null) return;
//
//     final snapshot =
//     await database.child("users/$email/myList").get();
//
//     if (snapshot.exists) {
//       final data = List<Map<String, dynamic>>.from(snapshot.value as List);
//       myMovies.assignAll(
//         data.map((e) => Results.fromJson(e)).toList(),
//       );
//       storage.saveMyList(data);
//     }
//   }
// }