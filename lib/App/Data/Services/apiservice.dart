import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/utils.dart';
import '../Models/hot_news_model.dart';
import '../Models/movie_category_model.dart';
import '../Models/movie_details_model.dart';
import '../Models/movie_model.dart';
import '../Models/movie_recommendation_model.dart';
import '../Models/movie_trailer_model.dart';
import '../Models/search_movie_model.dart';
import '../Models/top_rated_movie_model.dart';
import '../Models/trending_movie_model.dart';
import '../Models/tv_popular_movie_model.dart';
import '../Models/upcoming_movie_model.dart';
var key = "?api_key=$apiKey";
class ApiService {

  //now playing movie
  Future<Movies> fetchMovies() async {
    try {
      const endPoint = "movie/now_playing";
      final apiUrl = "$baseUrl$endPoint$key";

      final response = await http
          .get(Uri.parse(apiUrl));

      if (response.statusCode == 401 || response.statusCode == 403) {
        //TODO : Expired Login

          openAndCloseLoadingDialog(false);
          // onError();
      }

      if (response.statusCode == 502) {

          openAndCloseLoadingDialog(false);
          showSnackBar("wrong");

      }

      if (response.statusCode == 400 || jsonDecode(response.body)["error_code"] != null) {

          if (jsonDecode(response.body)["error_code"] == "invalid token") {
          openAndCloseLoadingDialog(false);
          try {
            showSnackBar(jsonDecode(response.body)["message"] ?? "wrong");
          } catch (e) {
            showSnackBar("wrong");
          }
        }
      }

      // if (response.statusCode == 200) {
      //   return Movies.fromJson(jsonDecode(response.body));
      //
      //   // print("ApiService GET Response : ${json.decode(response.body)}");
      // }
      // return jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Movies.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            "Server Error: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No Internet Connection");
    } on TimeoutException {
      throw Exception("Request Timeout");
    } catch (e) {
      throw Exception("Fetching error to find movies: $e");
    }
  }


  void showSnackBar(String message) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      titleText: Container(),
      borderRadius: 20,
      backgroundColor: Colors.black,
      colorText: Theme.of(Get.overlayContext!).colorScheme.surface,
      isDismissible: false,
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(15),
      /*mainButton: TextButton(
      child: Text('Undo'),
      onPressed: () {},
    ),*/
    );
  }

  Future<void> openAndCloseLoadingDialog(bool isShowHide) async {
    if (Get.overlayContext != null) {
      if (isShowHide) {
        showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      } else {
        Navigator.pop(Get.overlayContext!);
      }
    }
  }

  //upcoming movie
  Future<UpcomingMovies?> upCommingMovies() async{
    try{
      const endPoint= "movie/upcoming";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return UpcomingMovies.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception(
            "Server Error: ${response.statusCode}");
        // Exception("Failed to Load Movies");
      }
    }on SocketException {
      throw Exception("No Internet Connection");
    } on TimeoutException {
      throw Exception("Request Timeout");
    }
    catch(e){
      Exception("Fetching error to find movies: $e");
      return null;
    }
    return null;
  }

  //trending movie
  Future<TrendingMovies?> trendingMovies() async{
    try{
      const endPoint= "trending/movie/day";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return TrendingMovies.fromJson(jsonDecode(response.body));      }
      else{
        Exception("Failed to Load Movies");
      }
    }
    catch(e){
      Exception("Fetching error to find movies: $e");
      return null;
    }
    return null;
  }

  //top rated movie
  Future<TopRatedMovies?> topRatedMovies() async{
    try{
      const endPoint= "movie/top_rated";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return TopRatedMovies.fromJson(jsonDecode(response.body));      }
      else{
        Exception("Failed to Load Movies");
      }
    }
    catch(e){
      Exception("Fetching error to find movies: $e");
      return null;
    }
    return null;
  }

  //tv popular movie
  Future<TvPopularMovies?> tvPopularMovies() async{
    try{
      const endPoint= "tv/popular";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return TvPopularMovies.fromJson(jsonDecode(response.body));      }
      else{
        Exception("Failed to Load Movies");
      }
    }
    catch(e){
      Exception("Fetching error to find movies: $e");
      return null;
    }
    return null;
  }

  //movie details
  Future<MovieDetails?> movieDetails(int movieId) async{
    try{
      // movie/257048
      final endPoint= "movie/$movieId";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return MovieDetails.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception("Failed to Load Movies");
      }
    }
    catch(e){
      throw Exception("Fetching error to find movies: $e");
    }
  }

  //movie recommendations
  Future<MovieRecommendations?> movieRecommendations(int movieId) async{
    try{
      // movie/257048
      final endPoint= "movie/$movieId/recommendations";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return MovieRecommendations.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception("Failed to Load Movies");
      }
    }
    catch(e){
      throw Exception("Fetching error to find movies: $e");
    }
  }


  //search movies
  Future<SearchMovies?> searchMovies(String query) async{
    try{
      final endPoint= "search/movie";
      final apiUrl = "$baseUrl$endPoint$key&query=$query";
      final response = await http.get(Uri.parse(apiUrl),
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMjdkN2Q4NzljNzUwZWI4NTc0NzA1YWY5NDIzZjBlMiIsIm5iZiI6MTc3MDc4NTY1Ni43Mjk5OTk4LCJzdWIiOiI2OThjMGI3ODM1Y2I4YTFjMDgwOWMxYmIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.cZgkGU3EOHIH7PyIVLFCsVAFHOYzS7DEKXKfd0ENcvQ"
      });
      if(response.statusCode == 200){
        return SearchMovies.fromJson(jsonDecode(response.body));      }
      else if (response.statusCode == 404) {
        // Movie not found
        print("SearchMovies 404: No movies found for query: $query");
        return null;
      } else {
        print(
            "SearchMovies failed. Status: ${response.statusCode}, Body: ${response.body}");
        return null;
      }
      // else{
      //   throw Exception("Failed to Load Movies");
      // }
    }
    catch(e){
      throw Exception("Fetching error to find movies: $e");
    }
  }

  //hot news
  Future<HotNews?> hotNews() async{
    try{
      final endPoint= "trending/all/day";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      debugPrint("*************************");
      debugPrint(response.toString());
      debugPrint("*************************");

      if(response.statusCode == 200){
        return HotNews.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception("Failed to Load Hot News");
      }
    }
    catch(e){
      throw Exception("Fetching error to find Hot News: $e");
    }
  }

  Future<CategoryMovies?> categoryMovies() async{
    try{
      final endPoint= "genre/movie/list";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));;
      if(response.statusCode == 200){
        return CategoryMovies.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception("Failed to Load Category Movies");
      }
    } on SocketException {
      throw Exception("No Internet Connection");
    } on TimeoutException {
      throw Exception("Request Timeout");
    }
    catch(e){
      throw Exception("Fetching error to find Category Movies: $e");
    }
  }

  Future<GenreMovieResponse> fetchMoviesByGenre(int genreId) async {
    final url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId';

    final response = await http.get(
      Uri.parse(url),
      // headers: {
      //   "Accept": "application/json",
      //   "Content-Type": "application/json",
      // },
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMjdkN2Q4NzljNzUwZWI4NTc0NzA1YWY5NDIzZjBlMiIsIm5iZiI6MTc3MDc4NTY1Ni43Mjk5OTk4LCJzdWIiOiI2OThjMGI3ODM1Y2I4YTFjMDgwOWMxYmIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.cZgkGU3EOHIH7PyIVLFCsVAFHOYzS7DEKXKfd0ENcvQ",
      },
    );

    if (response.statusCode == 200) {
      return GenreMovieResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
          "Failed with status: ${response.statusCode}");
    }
  }

  Future<MovieTrailer?> fetchTrailerKey(int movieId) async {
    try{
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final movieTrailer = MovieTrailer.fromJson(data);

      return movieTrailer;
    }
    else if (response.statusCode == 404) {
      print("Trailer 404: Movie $movieId not found");
      return null;
    } else {
      print("Trailer failed. Status: ${response.statusCode}");
      return null;
    }}catch (e) {
    print("Trailer network or parsing error: $e");
    return null;
    }

    return null;
  }
  }

//movieid
//query = harry
