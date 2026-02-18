
class HotNews {
  int? page;
  List<Result>? results;
  int? totalPages;
  int? totalResults;

  HotNews({this.page, this.results, this.totalPages, this.totalResults});

  HotNews.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <Result>[];
      json['results'].forEach((v) {
        results!.add(new Result.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    // if (this.results != null) {
    //   data['results'] = this.results!.map((v) => v.toJson()).toList();
    // }
    if (data['results'] != null) {
      results = (data['results'] as List)
          .map((e) => Result.fromJson(e))
          .toList();
    } else {
      results = [];
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class Result {
  bool? adult;
  String? backdropPath;
  int? id;
  String? title;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? mediaType;
  String? originalLanguage;
  List<int>? genreIds;
  double? popularity;
  String? releaseDate;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? name;
  String? originalName;
  String? firstAirDate;
  List<String>? originCountry;

  Result(
      {this.adult,
        this.backdropPath,
        this.id,
        this.title,
        this.originalTitle,
        this.overview,
        this.posterPath,
        this.mediaType,
        this.originalLanguage,
        this.genreIds,
        this.popularity,
        this.releaseDate,
        this.video,
        this.voteAverage,
        this.voteCount,
        this.name,
        this.originalName,
        this.firstAirDate,
        this.originCountry});

  Result.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    id = json['id'];
    title = json['title'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    mediaType = json['media_type'];
    originalLanguage = json['original_language'];
    // genreIds = json['genre_ids'];
    genreIds = (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList();
    popularity = json['popularity'];
    releaseDate = json['release_date'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    name = json['name'];
    originalName = json['original_name'];
    firstAirDate = json['first_air_date'];
    originCountry = (json['origin_country'] as List<dynamic>?)?.map((e) => e as String).toList();

    // originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['id'] = this.id;
    data['title'] = this.title;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['poster_path'] = this.posterPath;
    data['media_type'] = this.mediaType;
    data['original_language'] = this.originalLanguage;
    data['genre_ids'] = this.genreIds;
    data['popularity'] = this.popularity;
    data['release_date'] = this.releaseDate;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['name'] = this.name;
    data['original_name'] = this.originalName;
    data['first_air_date'] = this.firstAirDate;
    data['origin_country'] = this.originCountry;
    return data;
  }
}
