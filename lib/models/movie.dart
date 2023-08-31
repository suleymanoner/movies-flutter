class Movie {
  Movie({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      backdropPath: json['backdrop_path'] ?? '',
      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
      voteAverage: json['vote_average'] ?? 0,
    );
  }
}
