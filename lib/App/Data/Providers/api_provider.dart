import 'package:get/get.dart';


class ApiProvider extends GetConnect {
  static const _apiKey = 'https://www.omdbapi.com/?i=tt3896198&apikey=fe70e995';


  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.themoviedb.org/3';
    httpClient.timeout = const Duration(seconds: 20);
  }


  Future<Response> getTrendingMovies() {
    return get('/trending/movie/day?api_key=$_apiKey');
  }


  Future<Response> searchMovies(String query) {
    return get('/search/movie?api_key=$_apiKey&query=$query');
  }


  Future<Response> getMovieDetails(int movieId) {
    return get('/movie/$movieId?api_key=$_apiKey');
  }
}