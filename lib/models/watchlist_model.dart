import 'package:equatable/equatable.dart';

class WatchlistTile extends Equatable {
  late int malId;
  late String imageUrl;
  late String title;
  late String titleEnglish;
  late String season;
  late int year;
  late String watchStatus;
  late String airStatus;

  WatchlistTile(
      {this.malId = 0,
      this.imageUrl = '',
      this.title = '',
      this.titleEnglish = '',
      this.season = '',
      this.year = 0,
      this.watchStatus = '',
      this.airStatus = ''});

  factory WatchlistTile.fromJson(Map<String, dynamic>? json) {
    return WatchlistTile(
        malId: json!['malId'],
        imageUrl: json['imageUrl'],
        title: json['title'],
        titleEnglish: json['titleEng'],
        season: json['season'],
        year: json['year'],
        watchStatus: json['watch_status'],
        airStatus: json['air_status']);
  }

  @override
  List<Object?> get props =>
      [malId, imageUrl, title, titleEnglish, season, year, watchStatus,airStatus];
}
