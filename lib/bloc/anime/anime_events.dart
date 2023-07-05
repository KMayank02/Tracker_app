import 'package:anime_track/models/anime_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class TopAnimeEvent {}

class TopAnimeInitialFetchEvent extends TopAnimeEvent {}


@immutable
abstract class AiringAnimeEvent {}

class AiringAnimeInitialFetchEvent extends AiringAnimeEvent {}


@immutable
abstract class MoviesEvent {}

class MoviesInitialFetchEvent extends MoviesEvent {}


@immutable
abstract class SeasonalAnimeEvent {}

class SeasonalAnimeInitialFetchEvent extends SeasonalAnimeEvent {}


@immutable
abstract class UpcomingAnimeEvent {}

class UpcomingAnimeInitialFetchEvent extends UpcomingAnimeEvent {}


@immutable
abstract class SearchAnimeEvent {}

class SearchAnimeInitialFetchEvent extends SearchAnimeEvent {
  final String query;

  SearchAnimeInitialFetchEvent({required this.query});
}


// @immutable
// abstract class RandomAnimeEvent {}

// class RandomAnimeInitialFetchEvent extends RandomAnimeEvent {}


@immutable
abstract class AnimeDataEvent {}

class AnimeDataInitialFetchEvent extends AnimeDataEvent {
  final int malId;

  AnimeDataInitialFetchEvent(this.malId);
}


@immutable
abstract class RelationsEvent {}

class RelationsInitialFetchEvent extends RelationsEvent {
  final Map<int, String> relIds;

  RelationsInitialFetchEvent(this.relIds);
}

@immutable
abstract class RecommendationsEvent {}

class RecommendationsInitialFetchEvent extends RecommendationsEvent {
  final int malId;

  RecommendationsInitialFetchEvent(this.malId);
}

@immutable
abstract class FavouriteBoolEvent {}

class FavouriteBoolInitialEvent extends FavouriteBoolEvent {
  final String uid;
  final Anime anime;

  FavouriteBoolInitialEvent(this.uid, this.anime);
}

@immutable
abstract class WatchStatusFetchEvent {}

class WatchStatusFetchInitialEvent extends WatchStatusFetchEvent {
  final String uid;
  final Anime anime;
  WatchStatusFetchInitialEvent(this.uid, this.anime);
}

@immutable
abstract class FavouritesFetchEvent {}

class FavouritesFetchInitialEvent extends FavouritesFetchEvent {
  final String uid;

  FavouritesFetchInitialEvent(this.uid);
}

@immutable
abstract class WatchlistFetchEvent {}

class WatchlistFetchInitialEvent extends WatchlistFetchEvent {
  final String uid;

  WatchlistFetchInitialEvent(this.uid);
}
