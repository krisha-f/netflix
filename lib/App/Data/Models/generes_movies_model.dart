import 'movie_model.dart';

class GenreMoviesModel {
  List<MovieResults>? results;

  GenreMoviesModel({this.results});

  factory GenreMoviesModel.fromJson(Map<String, dynamic> json) {
    return GenreMoviesModel(
      results: (json['results'] as List)
          .map((e) => MovieResults.fromJson(e))
          .toList(),
    );
  }
}