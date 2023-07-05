import 'package:anime_track/models/genre_model.dart';
import 'package:anime_track/models/relation_model.dart';
import 'package:anime_track/models/animetile_model.dart';
// import 'package:anime_track/models/Relation.dart';
import 'package:equatable/equatable.dart';

class Anime extends Equatable {
  late int malId;
  late String imageUrl;
  late String title;
  late String trailerUrl;
  late String titleEnglish;
  late String synopsis;
  late String type;
  late String status;
  late int episodes;
  late var score;
  late int airingDate;
  late String season;
  late List<Genre> genres;
  late Map<int, String> relations;
  late List<AnimeTile> recommendations;

  Anime({
    this.malId = 0,
    this.imageUrl = '',
    this.title = '',
    this.trailerUrl = '',
    this.titleEnglish = '',
    this.synopsis = '',
    this.status = '',
    this.episodes = 0,
    this.score = 0,
    this.airingDate = 0,
    this.season ='',
    this.genres = const [],
    this.relations = const {},
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    List<Genre> tempGenresList = [];
    
    for (int i = 0; i < json['genres'].length; i++) {
      Genre tmpGenre = Genre();
      tmpGenre.genreName = json['genres'][i]['name'];
      tmpGenre.malId = json['genres'][i]['mal_id'];
      tempGenresList.add(tmpGenre);
    }
    for (int i = 0; i < json['explicit_genres'].length; i++) {
      Genre tmpGenre = Genre();
      tmpGenre.genreName = json['explicit_genres'][i]['name'];
      tmpGenre.malId = json['explicit_genres'][i]['mal_id'];
      tempGenresList.add(tmpGenre);
    }
    for (int i = 0; i < json['themes'].length; i++) {
      Genre tmpGenre = Genre();
      tmpGenre.genreName = json['themes'][i]['name'];
      tmpGenre.malId = json['themes'][i]['mal_id'];
      tempGenresList.add(tmpGenre);
    }
    for (int i = 0; i < json['demographics'].length; i++) {
      Genre tmpGenre = Genre();
      tmpGenre.genreName = json['demographics'][i]['name'];
      tmpGenre.malId = json['demographics'][i]['mal_id'];
      tempGenresList.add(tmpGenre);
    }

    Map<int, String> tempRelationList = {};

    for (int i = 0; i < json['relations'].length; i++) {
      if (json['relations'][i]['relation'] == 'Prequel'||json['relations'][i]['relation'] == 'Sequel') {
        int id = json['relations'][i]['entry'][0]['mal_id'];
        String type = json['relations'][i]['relation'];
        tempRelationList[id] = type;
      }
    }

    String status = "";
    switch (json['status']) {
      case "Finished Airing":
        {
          status = "Completed";
          break;
        }

      case "Currently Airing":
        {
          status = "Airing";
          break;
        }

      case "Not yet aired":
        {
          status = "Upcoming";
          break;
        }

      default:
        {
          status = json['status']??'';
          break;
        }
    }

    return Anime(
      malId: json['mal_id'] ?? 0,
      imageUrl: json['images']['jpg']['large_image_url'] ?? '',
      title: json['title'] ?? '',
      trailerUrl: json['trailer']['url'] ?? '',
      titleEnglish: json['title_english'] ?? json['title'] ?? 'TBA',
      synopsis: json['synopsis'] ?? '',
      status: status,
      episodes: json['episodes'] ?? 0,
      score: json['score'] ?? 0,
      airingDate: json['year'] ?? 0,
      season: json['season']??'',
      genres: tempGenresList,
      relations: tempRelationList,
    );
  }

  @override
  List<Object?> get props => [
        malId,
        imageUrl,
        title,
        trailerUrl,
        titleEnglish,
        synopsis,
        status,
        episodes,
        score,
        airingDate,
        season,
        genres,
        relations,
      ];
}
