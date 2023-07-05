import 'package:anime_track/models/relation_model.dart';
import 'package:anime_track/models/anime_model.dart';
import 'package:anime_track/models/animetile_model.dart';
import 'package:anime_track/models/favourites_model.dart';
import 'package:anime_track/models/recommendation_model.dart';
import 'package:anime_track/models/watchlist_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class TopAnimeState {}

class TopAnimeInitial extends TopAnimeState {}

class TopAnimeFetchingLoadingState extends TopAnimeState {}

class TopAnimeFetchingErrorState extends TopAnimeState {}

class TopAnimeFetchingSuccessfulState extends TopAnimeState {
  final List<AnimeTile> topAnime;
  TopAnimeFetchingSuccessfulState({
    required this.topAnime,
  });
}

@immutable
abstract class AiringAnimeState {}

class AiringAnimeInitial extends AiringAnimeState {}

class AiringAnimeFetchingLoadingState extends AiringAnimeState {}

class AiringAnimeFetchingErrorState extends AiringAnimeState {}

class AiringAnimeFetchingSuccessfulState extends AiringAnimeState {
  final List<AnimeTile> airingAnime;
  AiringAnimeFetchingSuccessfulState({
    required this.airingAnime,
  });
}

@immutable
abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesFetchingLoadingState extends MoviesState {}

class MoviesFetchingErrorState extends MoviesState {}

class MoviesFetchingSuccessfulState extends MoviesState {
  final List<AnimeTile> movies;
  MoviesFetchingSuccessfulState({
    required this.movies,
  });
}

@immutable
abstract class SeasonalAnimeState {}

class SeasonalAnimeInitial extends SeasonalAnimeState {}

class SeasonalAnimeFetchingLoadingState extends SeasonalAnimeState {}

class SeasonalAnimeFetchingErrorState extends SeasonalAnimeState {}

class SeasonalAnimeFetchingSuccessfulState extends SeasonalAnimeState {
  final List<AnimeTile> seasonalAnime;
  SeasonalAnimeFetchingSuccessfulState({
    required this.seasonalAnime,
  });
}

@immutable
abstract class UpcomingAnimeState {}

class UpcomingAnimeInitial extends UpcomingAnimeState {}

class UpcomingAnimeFetchingLoadingState extends UpcomingAnimeState {}

class UpcomingAnimeFetchingErrorState extends UpcomingAnimeState {}

class UpcomingAnimeFetchingSuccessfulState extends UpcomingAnimeState {
  final List<AnimeTile> upcomingAnime;
  UpcomingAnimeFetchingSuccessfulState({
    required this.upcomingAnime,
  });
}

@immutable
abstract class SearchAnimeState {}

class SearchAnimeInitial extends SearchAnimeState {}

class SearchAnimeFetchingLoadingState extends SearchAnimeState {}

class SearchAnimeFetchingErrorState extends SearchAnimeState {}

class SearchAnimeFetchingSuccessfulState extends SearchAnimeState {
  final List<AnimeTile> searchedAnime;
  SearchAnimeFetchingSuccessfulState({
    required this.searchedAnime,
  });
}

// @immutable
// abstract class RandomAnimeState {}

// class RandomAnimeInitial extends RandomAnimeState {}

// class RandomAnimeFetchingLoadingState extends RandomAnimeState {}

// class RandomAnimeFetchingErrorState extends RandomAnimeState {}

// class RandomAnimeFetchingSuccessfulState extends RandomAnimeState {
//   final AnimeTile randomAnime;
//   RandomAnimeFetchingSuccessfulState({
//     required this.randomAnime,
//   });
// }

@immutable
abstract class AnimeDataState {}

class AnimeDataInitial extends AnimeDataState {}

class AnimeDataFetchingLoadingState extends AnimeDataState {}

class AnimeDataFetchingErrorState extends AnimeDataState {}

class AnimeDataFetchingSuccessfulState extends AnimeDataState {
  final Anime anime;
  AnimeDataFetchingSuccessfulState({
    required this.anime,
  });
}

@immutable
abstract class RelationsState {}

class RelationsInitial extends RelationsState {}

class RelationsFetchingLoadingState extends RelationsState {}

class RelationsFetchingErrorState extends RelationsState {}

class RelationsFetchingSuccessfulState extends RelationsState {
  final List<Relation> relations;
  RelationsFetchingSuccessfulState({
    required this.relations,
  });
}

@immutable
abstract class RecommendationsState {}

class RecommendationsInitial extends RecommendationsState {}

class RecommendationsFetchingLoadingState extends RecommendationsState {}

class RecommendationsFetchingErrorState extends RecommendationsState {}

class RecommendationsFetchingSuccessfulState extends RecommendationsState {
  final List<RecommendationTile> recommendations;
  RecommendationsFetchingSuccessfulState({
    required this.recommendations,
  });
}

@immutable
abstract class FavouriteBoolState {}

class FavouriteBoolInitial extends FavouriteBoolState {}

class FavouriteBoolLoadingState extends FavouriteBoolState {}

class FavouriteBoolErrorState extends FavouriteBoolState {}

class FavouriteBoolSuccessfulState extends FavouriteBoolState {
  final bool isFav;
  FavouriteBoolSuccessfulState({required this.isFav});
}

@immutable
abstract class WatchStatusState {}

class WatchStatusInitial extends WatchStatusState {}

class WatchStatusLoadingState extends WatchStatusState {}

class WatchStatusErrorState extends WatchStatusState {}

class WatchStatusSuccessfulState extends WatchStatusState {
  final String type;
  WatchStatusSuccessfulState({
    required this.type,
  });
}

@immutable
abstract class FavouritesFetchState {}

class FavouritesFetchInitial extends FavouritesFetchState {}

class FavouritesFetchLoadingState extends FavouritesFetchState {}

class FavouritesFetchErrorState extends FavouritesFetchState {}

class FavouritesFetchSuccessfulState extends FavouritesFetchState {
  final List<FavouriteTile> favourites;
  FavouritesFetchSuccessfulState({required this.favourites});
}

@immutable
abstract class WatchlistFetchState {}

class WatchlistFetchInitial extends WatchlistFetchState {}

class WatchlistFetchLoadingState extends WatchlistFetchState {}

class WatchlistFetchErrorState extends WatchlistFetchState {}

class WatchlistFetchSuccessfulState extends WatchlistFetchState {
  final List<WatchlistTile> watchlist;
  WatchlistFetchSuccessfulState({required this.watchlist});
}
