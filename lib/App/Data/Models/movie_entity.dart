class MovieEntity {
  final int id;
  final String? posterPath;
  final String? title;

  MovieEntity({
    required this.id,
    this.posterPath,
    this.title,
  });
}