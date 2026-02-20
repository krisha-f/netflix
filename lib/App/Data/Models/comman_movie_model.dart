import 'movie_model.dart';

class MyMovie {
  final int id;
  final String title;
  final String? posterPath;

  MyMovie({
    required this.id,
    required this.title,
    this.posterPath,
  });

  // 🔥 From API model
  factory MyMovie.fromMovieResults(MovieResults movie) {
    return MyMovie(
      id: movie.id ?? 0,
      title: movie.title ?? "",
      posterPath: movie.posterPath,
    );
  }

  // 🔥 From Firebase JSON
  factory MyMovie.fromJson(Map<dynamic, dynamic> json) {
    return MyMovie(
      id: json["id"],
      title: json["title"],
      posterPath: json["posterPath"],
    );
  }

  // 🔥 To Firebase JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "posterPath": posterPath,
    };
  }
}