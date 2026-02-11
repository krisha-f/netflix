
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:netflix/App/Data/Services/utils.dart';

import '../Models/movie_model.dart';
var key = "?=api_key=$apiKey";
class ApiService {
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
}

