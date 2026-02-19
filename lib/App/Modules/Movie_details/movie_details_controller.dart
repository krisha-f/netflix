import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../../Data/Models/movie_details_model.dart';
import '../../Data/Models/movie_recommendation_model.dart';
import '../../Data/Models/movie_trailer_model.dart';
import '../../Data/Services/apiservice.dart';
import '../../Data/Services/utils.dart';

class MovieDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late int movieId;

  late Future<MovieDetails?> movieDetailsData;
  late Future<MovieRecommendations?> movieRecommendationsData;

  // late Future<MovieTrailer?> movieTrailerData;
  // MovieTrailer? movieTrailerData;

  late TabController tabController;

  final ApiService apiService = ApiService();
  final database = FirebaseDatabase.instance.ref();

  RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;


  @override
  void onInit() {
    super.onInit();

    movieId = Get.arguments;

    tabController = TabController(length: 4, vsync: this);
    update();

    movieDetailsData = apiService.movieDetails(movieId);
    movieRecommendationsData = apiService.movieRecommendations(movieId);


    loadReviews();
  }

  Future<MovieTrailer?> fetchTrailer(int id) async {
    return await apiService.fetchTrailerKey(id);
  }

  Future<void> addReview(String text, double rating) async {
    if (uid == null) return;
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "Unknown";


    final ref = database
        .child("movieReviews/$movieId")
        .push();

    await ref.set({
      "userId": uid,
      "review": text,
      "rating": rating,
      "time": DateTime.now().toString(),
      "email":userEmail,
    });




    loadReviews();
  }

  Future<void> loadReviews() async {
    final snapshot =
    await database.child("movieReviews/$movieId").get();

    if (!snapshot.exists) return;

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    reviews.assignAll(
      data.values
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }


}


//
// import 'package:get/get.dart';
// import '../../Data/Models/movie_details_model.dart';
// import '../../Data/Models/movie_recommendation_model.dart';
// import '../../Data/Services/apiservice.dart';
//
// class MovieDetailsController extends GetxController{
//   late int movieId;
//
//   late Future<MovieDetails?> movieDetailsData;
//   late Future<MovieRecommendations?> movieRecommendationsData;
//   final ApiService apiService = ApiService();
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     movieId = Get.arguments;
//     movieDetailsData = apiService.movieDetails(movieId);
//     movieRecommendationsData = apiService.movieRecommendations(movieId);
//     // movieDetailsData =apiService.movieDetails();
//   }
//
// }