import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Services/storage_service.dart';

class MyListController extends GetxController {
  final storage = Get.find<StorageService>();
  final database = FirebaseDatabase.instance.ref();

  RxList<Results> myMovies = <Results>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
    syncWithFirebase();
  }

  void loadLocalData() {
    final data = storage.getMyList();
    myMovies.assignAll(
      data.map((e) => Results.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  void addMovie(Results movie) {
    if (isAdded(movie)) {
      myMovies.removeWhere((m) => m.id == movie.id);
    } else {
      myMovies.add(movie);
    }

    storage.saveMyList(myMovies.map((e) => e.toJson()).toList());
    saveToFirebase();
  }

  bool isAdded(Results movie) {
    return myMovies.any((m) => m.id == movie.id);
  }

  void saveToFirebase() {
    final email = storage.userEmail;

    debugPrint("*********************");
    debugPrint(email);
    debugPrint("*********************");


    if (email == null) return;



    database.child("users/$email/myList").set(
      myMovies.map((e) => e.toJson()).toList(),
    );
  }

  void syncWithFirebase() async {
    final email = storage.userEmail;
    if (email == null) return;

    final snapshot =
    await database.child("users/$email/myList").get();

    if (snapshot.exists) {
      final data = List<Map<String, dynamic>>.from(snapshot.value as List);
      myMovies.assignAll(
        data.map((e) => Results.fromJson(e)).toList(),
      );
      storage.saveMyList(data);
    }
  }
}