import 'dart:ffi';

import 'package:anime_track/constants.dart';
import 'package:anime_track/models/relation_model.dart';
import 'package:anime_track/models/favourites_model.dart';
import 'package:anime_track/models/watchlist_model.dart';
import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:anime_track/models/animetile_model.dart';

import '../../models/anime_model.dart';
import '../../models/recommendation_model.dart';

class AnimeRepo {
  final _firestore = FirebaseFirestore.instance;

  List<DioExceptionType> dioErrors = [
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.badCertificate,
    DioExceptionType.badResponse,
    DioExceptionType.cancel,
    DioExceptionType.connectionError,
    DioExceptionType.unknown,
  ];


      final Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5)));

  Future<List<AnimeTile>> getTopAnime() async {
    try {
      int month = DateTime.now().month;
      final response = await dio.get(topUrl);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        rethrow;
      }
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnimeTile>> getUpcomingAnime() async {
    try {
      int month = DateTime.now().month;
      final response = await dio.get(getUpcomingSeason().last);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnimeTile>> getSeasonalAnime() async {
    try {
      final response = await dio.get(seasonalUrl);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnimeTile>> getAiringAnime() async {
    try {
      final response = await dio.get(airingUrl);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        rethrow;
      }
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnimeTile>> getMovies() async {
    try {
      final response = await dio.get(movieUrl);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        rethrow;
      }
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<AnimeTile> getRandomAnime() async {
  //   try {
  //     final response = await dio.get(randomUrl);
  //     AnimeTile anime = AnimeTile.fromJson(response.data['data']);
  //     return anime;
  //   } on DioException catch (e) {
  //     if (dioErrors.contains(e.type)) {
  //       rethrow;
  //     } else {
  //       rethrow;
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<List<AnimeTile>> searchAnime(String query) async {
    try {
      final response = await dio.get(searchUrl + query);

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<AnimeTile> anime_tiles =
          items.map((data) => AnimeTile.fromJson(data)).toList();
      return anime_tiles;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Anime> getAnimeData(int mal_id) async {
    try {
      final response = await dio.get('$animeUrl/$mal_id/full');

      // if (response.statusCode != 200) throw Exception();

      Anime anime = Anime.fromJson(response.data['data']);
      return anime;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RecommendationTile>> getRecommendedations(int malId) async {
    try {
      final response =
          await dio.get('$animeUrl/$malId/recommendations');

      // if (response.statusCode != 200) throw Exception();

      List items = response.data['data'];
      List<RecommendationTile> recommendations =
          items.map((data) => RecommendationTile.fromJson(data)).toList();
      return recommendations;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Relation>> getRelationData(Map<int, String> relIds) async {
    try {
      List<Relation> relations = [];
      for (var id in relIds.keys) {
        final response =
            await dio.get('https://api.jikan.moe/v4/anime/$id');
        if (response.statusCode != 200) break;
        Relation relation = Relation.fromJson(response.data['data']);
        relation.relationName = relIds[id]!;
        relations.add(relation);
      }
      return relations;
    } on DioException catch (e) {
      if (dioErrors.contains(e.type)) {
        rethrow;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isFavourite(String fetchedUid, Anime anime) async {
    try {
      var docRef = _firestore.collection("favourites").doc(fetchedUid);
      bool isFav = false;
      await docRef.get().then((value) {
        var items = value.data()!;
        Map<String, dynamic> map = items["Anime"];
        if (map["${anime.malId}"] != null) {
          isFav = true;
        }
      });
      return isFav;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchWatchStatus(String fetchedUid, Anime anime) async {
    try {
      var docRef = _firestore.collection("watchlist").doc(fetchedUid);
      String type = "";
      await docRef.get().then((value) {
        var items = value.data()!;
        Map<String, dynamic> map = items["Anime"];
        if (map["${anime.malId}"] != null) {
          type = map["${anime.malId}"]["watch_status"];
        }
      });
      return type;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FavouriteTile>> fetchFavourites(String fetchedUid) async {
    try {
      var docRef = _firestore.collection("favourites").doc(fetchedUid);
      List<FavouriteTile> favourites = [];

      await docRef.get().then((value) {
        var items = value.data()!;
        Map<String, dynamic> map = items["Anime"];

        map.forEach((k, v) async {
          if (map[k] != null) {
            favourites.add(FavouriteTile.fromJson(map[k]));
          }
        });
      });
      return favourites;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WatchlistTile>> fetchWatchlist(String fetchedUid) async {
    try {
      var docRef = _firestore.collection("watchlist").doc(fetchedUid);
      List<WatchlistTile> watchlist = [];

      await docRef.get().then((value) {
        var items = value.data()!;
        Map<String, dynamic> map = items["Anime"];

        map.forEach((k, v) async {
          if (map[k] != null) {
            watchlist.add(WatchlistTile.fromJson(map[k]));
          }
        });
      });
      return watchlist;
    } catch (e) {
      rethrow;
    }
  }
}
