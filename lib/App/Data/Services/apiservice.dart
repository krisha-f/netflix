
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/utils.dart';

import '../Models/movie_details_model.dart';
import '../Models/movie_model.dart';
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

}

