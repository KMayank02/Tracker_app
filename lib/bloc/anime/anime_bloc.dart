import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anime_track/models/anime_model.dart';
import 'package:anime_track/models/animetile_model.dart';
import 'package:anime_track/models/favourites_model.dart';
import 'package:anime_track/models/watchlist_model.dart';
import 'package:anime_track/data/repo/anime_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc_with_apis/features/posts/models/post_data_ui_model.dart';
// import 'package:flutter_bloc_with_apis/features/posts/repos/posts_repo.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../../models/relation_model.dart';
import '../../models/recommendation_model.dart';
import 'anime_events.dart';
import 'anime_states.dart';

class TopAnimeBloc extends Bloc<TopAnimeEvent, TopAnimeState> {
  TopAnimeBloc() : super(TopAnimeInitial()) {
    on<TopAnimeInitialFetchEvent>(
      (event, emit) async {
        emit(TopAnimeFetchingLoadingState());
        try {
          List<AnimeTile> topanime = await AnimeRepo().getTopAnime();

          emit(TopAnimeFetchingSuccessfulState(topAnime: topanime));
        } catch (error) {
          emit(TopAnimeFetchingErrorState());
        }
      },
    );
  }
}

class AiringAnimeBloc extends Bloc<AiringAnimeEvent, AiringAnimeState> {
  AiringAnimeBloc() : super(AiringAnimeInitial()) {
    on<AiringAnimeInitialFetchEvent>(
      (event, emit) async {
        emit(AiringAnimeFetchingLoadingState());
        try {
          List<AnimeTile> airinganime = await AnimeRepo().getAiringAnime();

          emit(AiringAnimeFetchingSuccessfulState(airingAnime: airinganime));
        } catch (error) {
          emit(AiringAnimeFetchingErrorState());
        }
      },
    );
  }
}

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesInitial()) {
    on<MoviesInitialFetchEvent>(
      (event, emit) async {
        emit(MoviesFetchingLoadingState());
        try {
          List<AnimeTile> movies = await AnimeRepo().getMovies();

          emit(MoviesFetchingSuccessfulState(movies: movies));
        } catch (error) {
          emit(MoviesFetchingErrorState());
        }
      },
    );
  }
}

class SeasonalAnimeBloc extends Bloc<SeasonalAnimeEvent, SeasonalAnimeState> {
  SeasonalAnimeBloc() : super(SeasonalAnimeInitial()) {
    on<SeasonalAnimeInitialFetchEvent>(
      (event, emit) async {
        emit(SeasonalAnimeFetchingLoadingState());
        try {
          List<AnimeTile> seasonalanime = await AnimeRepo().getSeasonalAnime();

          emit(SeasonalAnimeFetchingSuccessfulState(
              seasonalAnime: seasonalanime));
        } catch (error) {
          emit(SeasonalAnimeFetchingErrorState());
        }
      },
    );
  }
}

class UpcomingAnimeBloc extends Bloc<UpcomingAnimeEvent, UpcomingAnimeState> {
  UpcomingAnimeBloc() : super(UpcomingAnimeInitial()) {
    on<UpcomingAnimeInitialFetchEvent>(
      (event, emit) async {
        emit(UpcomingAnimeFetchingLoadingState());
        try {
          List<AnimeTile> upcominganime = await AnimeRepo().getUpcomingAnime();

          emit(UpcomingAnimeFetchingSuccessfulState(
              upcomingAnime: upcominganime));
        } catch (error) {
          emit(UpcomingAnimeFetchingErrorState());
        }
      },
    );
  }
}

class SearchAnimeBloc extends Bloc<SearchAnimeEvent, SearchAnimeState> {
  SearchAnimeBloc() : super(SearchAnimeInitial()) {
    on<SearchAnimeInitialFetchEvent>(
      (event, emit) async {
        emit(SearchAnimeFetchingLoadingState());
        try {
          List<AnimeTile> topanime = await AnimeRepo().searchAnime(event.query);

          emit(SearchAnimeFetchingSuccessfulState(searchedAnime: topanime));
        } catch (error) {
          emit(SearchAnimeFetchingErrorState());
        }
      },
    );
  }
}

// class RandomAnimeBloc extends Bloc<RandomAnimeEvent, RandomAnimeState> {
//   RandomAnimeBloc() : super(RandomAnimeInitial()) {
//     on<RandomAnimeInitialFetchEvent>(
//       (event, emit) async {
//         emit(RandomAnimeFetchingLoadingState());
//         try {
//           AnimeTile radnomanime = await AnimeRepo().getRandomAnime();

//           emit(RandomAnimeFetchingSuccessfulState(randomAnime: radnomanime));
//         } catch (error) {
//           emit(RandomAnimeFetchingErrorState());
//         }
//       },
//     );
//   }
// }

class AnimeDataBloc extends Bloc<AnimeDataEvent, AnimeDataState> {
  AnimeDataBloc() : super(AnimeDataInitial()) {
    on<AnimeDataInitialFetchEvent>((event, emit) async {
      emit(AnimeDataFetchingLoadingState());
      try {
        Anime anime = await AnimeRepo().getAnimeData(event.malId);

        emit(AnimeDataFetchingSuccessfulState(anime: anime));
      } catch (error) {
        emit(AnimeDataFetchingErrorState());
      }
    });
  }
}

class RelationsBloc
    extends Bloc<RelationsEvent, RelationsState> {
  RelationsBloc() : super(RelationsInitial()) {
    on<RelationsInitialFetchEvent>(
      (event, emit) async {
        emit(RelationsFetchingLoadingState());
        try {
          List<Relation> relations =
              await AnimeRepo().getRelationData(event.relIds);

          emit(RelationsFetchingSuccessfulState(
              relations: relations));
        } catch (error) {
          print(error);
          emit(RelationsFetchingErrorState());
        }
      },
    );
  }
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc() : super(RecommendationsInitial()) {
    on<RecommendationsInitialFetchEvent>(
      (event, emit) async {
        emit(RecommendationsFetchingLoadingState());
        try {
          List<RecommendationTile> recommendations =
              await AnimeRepo().getRecommendedations(event.malId);

          emit(RecommendationsFetchingSuccessfulState(
              recommendations: recommendations));
        } catch (error) {
          print(error);
          emit(RecommendationsFetchingErrorState());
        }
      },
    );
  }
}

class FavouriteBoolBloc extends Bloc<FavouriteBoolEvent, FavouriteBoolState> {
  FavouriteBoolBloc() : super(FavouriteBoolInitial()) {
    on<FavouriteBoolInitialEvent>((event, emit) async {
      emit(FavouriteBoolLoadingState());
      try {
        bool isFav = await AnimeRepo().isFavourite(event.uid, event.anime);
        emit(FavouriteBoolSuccessfulState(isFav: isFav));
      } catch (error) {
        emit(FavouriteBoolErrorState());
      }
    });
  }
}

class WatchStatusBloc extends Bloc<WatchStatusFetchEvent, WatchStatusState> {
  WatchStatusBloc() : super(WatchStatusInitial()) {
    on<WatchStatusFetchInitialEvent>((event, emit) async {
      // emit(FavouritesFetchingLoadingState());
      try {
        String type =
            await AnimeRepo().fetchWatchStatus(event.uid, event.anime);
        emit(WatchStatusSuccessfulState(type: type));
      } catch (error) {
        emit(WatchStatusErrorState());
      }
    });
  }
}

class FavouritesFetchBloc
    extends Bloc<FavouritesFetchEvent, FavouritesFetchState> {
  FavouritesFetchBloc() : super(FavouritesFetchInitial()) {
    on<FavouritesFetchInitialEvent>((event, emit) async {
      emit(FavouritesFetchLoadingState());
      try {
        List<FavouriteTile> favourites =
            await AnimeRepo().fetchFavourites(event.uid);
        emit(FavouritesFetchSuccessfulState(favourites: favourites));
      } catch (error) {
        emit(FavouritesFetchErrorState());
      }
    });
  }
}

class WatchlistFetchBloc
    extends Bloc<WatchlistFetchEvent, WatchlistFetchState> {
  WatchlistFetchBloc() : super(WatchlistFetchInitial()) {
    on<WatchlistFetchInitialEvent>((event, emit) async {
      emit(WatchlistFetchLoadingState());
      try {
        List<WatchlistTile> watchlist =
            await AnimeRepo().fetchWatchlist(event.uid);
        emit(WatchlistFetchSuccessfulState(watchlist: watchlist));
      } catch (error) {
        emit(WatchlistFetchErrorState());
      }
    });
  }
}
