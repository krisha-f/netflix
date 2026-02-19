
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/apiservice.dart';
import '../../Data/Models/movie_category_model.dart';
import '../../Data/Models/movie_entity.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Models/movie_trailer_model.dart';
import '../../Data/Models/top_rated_movie_model.dart' as topRated;
import '../../Data/Models/trending_movie_model.dart' as trendMovie;
import '../../Data/Models/tv_popular_movie_model.dart' as tvPopular;
import '../../Data/Models/upcoming_movie_model.dart' as upComing;
import '../../Data/Services/connectivity_service.dart';
import '../../Data/Services/network_service.dart';
import '../../Data/Services/socket_service.dart';
import '../../Data/Services/utils.dart';
import '../MyList/mylist_controller.dart';

class HomeController extends GetxController{
 Future<Movies?>? moviesData;
  Future<upComing.UpcomingMovies?>? upcomingMoviesData;
   Future<trendMovie.TrendingMovies?>? treadingMoviesData;
  Future<topRated.TopRatedMovies?>? topRatedMoviesData;
   Future<tvPopular.TvPopularMovies?>? tvPopularMoviesData;
   Future<CategoryMovies?>? categoriesMoviesData;

  final ScrollController scrollController = ScrollController();

  Rx<MovieResults?> currentMovie = Rx<MovieResults?>(null);
  final ApiService apiService = ApiService();
  final myListController = Get.find<MyListController>();
  // var currentMovie = Rxn<Results>();

  var genres = <Genres>[].obs;
  var selectedGenre = Rxn<Genres>();
  RxList<MovieResults> selectedGenreMovies = <MovieResults>[].obs;
  RxBool isGenreLoading = false.obs;
  int selectedIndex = -1;
  bool _isRequestRunning = false;

  RxInt selectedPosterIndex = (-1).obs;
  RxInt selectedUpcomingPosterIndex = (-1).obs;
  RxInt selectedTrendingPosterIndex = (-1).obs;
  RxInt selectedTopRatedPosterIndex = (-1).obs;
  RxInt selectedTvPopularPosterIndex = (-1).obs;


 @override
  void onInit() {
    super.onInit();
    moviesData =apiService.fetchMovies();
    upcomingMoviesData = apiService.upCommingMovies();
    treadingMoviesData = apiService.trendingMovies();
    topRatedMoviesData = apiService.topRatedMovies();
    tvPopularMoviesData = apiService.tvPopularMovies();
    categoriesMoviesData = apiService.categoryMovies();
    loadGenres();
  }


  // Future<void> loadAllData() async {
  //   try {
  //     moviesData = apiService.fetchMovies();
  //
  //     upcomingMoviesData = apiService.upCommingMovies();
  //
  //     treadingMoviesData = apiService.trendingMovies();
  //
  //     topRatedMoviesData = apiService.topRatedMovies();
  //
  //     tvPopularMoviesData = apiService.tvPopularMovies();
  //
  //     categoriesMoviesData = apiService.categoryMovies();
  //
  //     await loadGenres();
  //
  //   } catch (e) {
  //     debugPrint("HOME LOAD ERROR: $e");
  //   }
  // }



  Future<void> loadGenres() async {
    try{
    final result = await apiService.categoryMovies();
    if (result != null) {
      genres.value = result.genres ?? [];
    }}catch (e) {
      debugPrint("Genre Error: $e");
    }
  }


  Future<void> selectGenre(Genres genre) async {
    if (_isRequestRunning) return;

    try {
      _isRequestRunning = true;
      selectedGenre.value = genre;
      isGenreLoading.value = true;

      final response =
      await apiService.fetchMoviesByGenre(genre.id ?? 0);

      selectedGenreMovies.assignAll(
          response.results ?? <MovieResults>[]);
    } catch (e) {
      debugPrint("GENRE ERROR: $e");
    } finally {
      isGenreLoading.value = false;
      _isRequestRunning = false;
    }
  }

  // Future<List<MovieEntity>> fetchUpcomingMovies() async {
  //   final response = await apiService.getUpcomingMovies();
  //
  //   return response.results?.map((e) {
  //     return MovieEntity(
  //       id: e.id ?? 0,
  //       posterPath: e.posterPath,
  //       title: e.title,
  //     );
  //   }).toList() ?? [];
  // }
  //
  // Future<List<MovieEntity>> fetchTrendingMovies() async {
  //   final response = await apiService.getTrendingMovies();
  //
  //   return response.results?.map((e) {
  //     return MovieEntity(
  //       id: e.id ?? 0,
  //       posterPath: e.posterPath,
  //       title: e.title,
  //     );
  //   }).toList() ?? [];
  // }


}