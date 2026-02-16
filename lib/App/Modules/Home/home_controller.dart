
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/apiservice.dart';
import '../../Data/Models/movie_category_model.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Models/top_rated_movie_model.dart' as topRated;
import '../../Data/Models/trending_movie_model.dart' as trendMovie;
import '../../Data/Models/tv_popular_movie_model.dart' as tvPopular;
import '../../Data/Models/upcoming_movie_model.dart' as upComing;
import '../../Data/Services/utils.dart';
import '../MyList/mylist_controller.dart';

class HomeController extends GetxController{
  late Future<Movies?> moviesData;
  late Future<upComing.UpcomingMovies?> upcomingMoviesData;
  late Future<trendMovie.TrendingMovies?> treadingMoviesData;
  late Future<topRated.TopRatedMovies?> topRatedMoviesData;
  late Future<tvPopular.TvPopularMovies?> tvPopularMoviesData;
  late Future<CategoryMovies?> categoriesMoviesData;

  final ScrollController scrollController = ScrollController();

  Rx<Results?> currentMovie = Rx<Results?>(null);
  final ApiService apiService = ApiService();
  final myListController = Get.find<MyListController>();
  // var currentMovie = Rxn<Results>();

  var genres = <Genres>[].obs;
  var selectedGenre = Rxn<Genres>();
  RxList<Results> selectedGenreMovies = <Results>[].obs;
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
    loadGenres();
    moviesData =apiService.fetchMovies();
    upcomingMoviesData = apiService.upCommingMovies();
    treadingMoviesData = apiService.trendingMovies();
    topRatedMoviesData = apiService.topRatedMovies();
    tvPopularMoviesData = apiService.tvPopularMovies();
    categoriesMoviesData = apiService.categoryMovies();
    loadGenres();
  }

  Future<void> loadGenres() async {
    final result = await apiService.categoryMovies();
    if (result != null) {
      genres.value = result.genres ?? [];
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
          response.results ?? <Results>[]);
    } catch (e) {
      debugPrint("GENRE ERROR: $e");
    } finally {
      isGenreLoading.value = false;
      _isRequestRunning = false;
    }
  }

}