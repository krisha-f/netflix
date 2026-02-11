
import 'package:get/get.dart';
import 'package:netflix/App/Data/Services/apiservice.dart';

import '../../Data/Models/movie_model.dart';
import '../../Data/Models/top_rated_movie_model.dart';
import '../../Data/Models/trending_movie_model.dart';
import '../../Data/Models/tv_popular_movie_model.dart';
import '../../Data/Models/upcoming_movie_model.dart';

class HomeController extends GetxController{
  late Future<Movies?> moviesData;
  late Future<UpcomingMovies?> upcomingMoviesData;
  late Future<TrendingMovies?> treadingMoviesData;
  late Future<TopRatedMovies?> topRatedMoviesData;
  late Future<TvPopularMovies?> tvPopularMoviesData;


  final ApiService apiService = ApiService();


  @override
  void onInit() {
    super.onInit();
    moviesData =apiService.fetchMovies();
    upcomingMoviesData = apiService.upCommingMovies();
    treadingMoviesData = apiService.trendingMovies();
    topRatedMoviesData = apiService.topRatedMovies();
    tvPopularMoviesData = apiService.tvPopularMovies();
  }


}