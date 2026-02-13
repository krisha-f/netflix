
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/utils.dart';

import '../Models/hot_news_model.dart';
import '../Models/movie_category_model.dart';
import '../Models/movie_details_model.dart';
import '../Models/movie_model.dart';
import '../Models/movie_recommendation_model.dart';
import '../Models/search_movie_model.dart';
import '../Models/top_rated_movie_model.dart';
import '../Models/trending_movie_model.dart';
import '../Models/tv_popular_movie_model.dart';
import '../Models/upcoming_movie_model.dart';
var key = "?api_key=$apiKey";
class ApiService {

  //now playing movie
  Future<Movies?> fetchMovies() async{
    try{
      const endPoint= "movie/now_playing";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return Movies.fromJson(jsonDecode(response.body));      }
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

  //upcoming movie
  Future<UpcomingMovies?> upCommingMovies() async{
    try{
      const endPoint= "movie/upcoming";
      final apiUrl = "$baseUrl$endPoint$key";
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return UpcomingMovies.fromJson(jsonDecode(response.body));      }
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
      else{
        throw Exception("Failed to Load Movies");
      }
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
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return CategoryMovies.fromJson(jsonDecode(response.body));      }
      else{
        throw Exception("Failed to Load Category Movies");
      }
    }
    catch(e){
      throw Exception("Fetching error to find Category Movies: $e");
    }
  }

  Future<CategoryMovies?> fetchMoviesByGenre(int genreId) async {
    try {
      final endPoint = "discover/movie";
      final apiUrl =
          "$baseUrl$endPoint?api_key=$apiKey&with_genres=$genreId";

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return CategoryMovies.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load genre movies");
      }
    } catch (e) {
      throw Exception("Fetching error genre movies: $e");
    }
  }

}


//movieid
//query = harry
