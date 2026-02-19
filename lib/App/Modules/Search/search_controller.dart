import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Data/Models/movie_trailer_model.dart';
import '../../Data/Models/search_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Services/apiservice.dart';

class CustomSearchController extends GetxController {
  final ApiService apiService = ApiService();
  final TextEditingController sController = TextEditingController();

  Rx<SearchMovies?> searchMovie = Rx<SearchMovies?>(null);
  RxBool isSearching = false.obs;
  RxString query = ''.obs;

  late Future<TrendingMovies?> trendingMovies;

  @override
  void onInit() {
    super.onInit();
    trendingMovies = apiService.trendingMovies();

    debounce(query, (value) {
      if (value.length >= 3) {
        search(value);
      }
    }, time: const Duration(milliseconds: 600));
  }

  Future<MovieTrailer?> fetchTrailer(int id) async {
    return await apiService.fetchTrailerKey(id);
  }

  Future<void> search(String text) async {
    try {
      isSearching.value = true;
      final result = await apiService.searchMovies(text);
      searchMovie.value = result;
    } catch (e) {
      print("Search Error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  void updateQuery(String text) {
    query.value = text;
    if (text.isEmpty) {
      searchMovie.value = null;
    }
  }
}