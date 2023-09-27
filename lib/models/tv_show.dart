class TvShow {
  TvShow({
    required this.backdropPath,
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  final String backdropPath;
  final String firstAirDate;
  final int id;
  final String name;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String posterPath;
  final double voteAverage;

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      backdropPath: json['backdrop_path'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }
}

class CreatedBy {
  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.profilePath,
  });

  final int id;
  final String creditId;
  final String name;
  final String profilePath;
}

class Genre {
  Genre({required this.id, required this.name});

  final int id;
  final String name;
}

class LastEpisodeToAir {
  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.airDate,
    required this.runtime,
    required this.stillPath,
  });

  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final String airDate;
  final int runtime;
  final String stillPath;
}

class ProductionCompany {
  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  final int id;
  final String logoPath;
  final String name;
  final String originCountry;
}

class Season {
  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final int seasonNumber;
  final double voteAverage;
}

class IndividualTvShow {
  IndividualTvShow({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.productionCompanies,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.voteAverage,
  });

  final bool adult;
  final String backdropPath;
  final dynamic createdBy;
  final String firstAirDate;
  final List<dynamic> genres;
  final String homepage;
  final int id;
  final dynamic languages;
  final String lastAirDate;
  final dynamic lastEpisodeToAir;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final dynamic originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String posterPath;
  final List<dynamic> productionCompanies;
  final List<dynamic> seasons;
  final String status;
  final String tagline;
  final double voteAverage;

  factory IndividualTvShow.fromJson(Map<String, dynamic> json) {
    return IndividualTvShow(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? '',
      createdBy: json['created_by'] ?? {},
      firstAirDate: json['first_air_date'] ?? '',
      genres: json['genres'] ?? [],
      homepage: json['homepage'] ?? '',
      id: json['id'] ?? 0,
      languages: json['languages'] ?? [],
      lastAirDate: json['last_air_date'] ?? '',
      lastEpisodeToAir: json['last_episode_to_air'] ?? {},
      name: json['name'] ?? '',
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      originCountry: json['origin_country'] ?? {},
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      productionCompanies: json['production_companies'] ?? [],
      seasons: json['seasons'] ?? [],
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      voteAverage: json['vote_average'] ?? 0,
    );
  }
}
