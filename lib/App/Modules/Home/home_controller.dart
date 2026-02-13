
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/apiservice.dart';
import '../../Data/Models/movie_category_model.dart';
import '../../Data/Models/movie_model.dart';
import '../../Data/Models/top_rated_movie_model.dart' hide Results;
import '../../Data/Models/trending_movie_model.dart' hide Results;
import '../../Data/Models/tv_popular_movie_model.dart' hide Results;
import '../../Data/Models/upcoming_movie_model.dart' hide Results;
import '../../Data/Services/utils.dart';
import '../MyList/mylist_controller.dart';

class HomeController extends GetxController{
  late Future<Movies?> moviesData;
  late Future<UpcomingMovies?> upcomingMoviesData;
  late Future<TrendingMovies?> treadingMoviesData;
  late Future<TopRatedMovies?> topRatedMoviesData;
  late Future<TvPopularMovies?> tvPopularMoviesData;
  late Future<CategoryMovies?> categoriesMoviesData;

  final ScrollController scrollController = ScrollController();


  final ApiService apiService = ApiService();
  final myListController = Get.find<MyListController>();
  var currentMovie = Rxn<Results>();

  var genres = <Genres>[].obs;
  var selectedGenre = Rxn<Genres>();
  var selectedGenreMovies = Rxn<Future<CategoryMovies?>>();
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
    // loadGenres();
  }

  // 🔥 LOAD GENRES LIST
  Future<void> loadGenres() async {
    final result = await apiService.categoryMovies();
    if (result != null) {
      genres.value = result.genres ?? [];
    }
  }

  // 🔥 FETCH MOVIES BY GENRE
  Future<void> selectGenre(Genres genre) async {
    selectedGenre.value = genre;
    selectedGenreMovies.value =
         apiService.fetchMoviesByGenre(genre.id ?? 0);
  }

}