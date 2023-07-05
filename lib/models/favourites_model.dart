import 'package:equatable/equatable.dart';

class FavouriteTile extends Equatable {
  late int malId;
  late String imageUrl;
  late String title;
  late String titleEnglish;
  late String season;
  late int year;

  FavouriteTile({
    this.malId = 0,
    this.imageUrl = '',
    this.title = '',
    this.titleEnglish = '',
    this.season = '',
    this.year = 0
  });

  factory FavouriteTile.fromJson(Map<String, dynamic>? json) {

    return FavouriteTile(
      malId: json!['malId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      titleEnglish: json['titleEng'],
      season: json['season'],
      year: json['year']
    );
  }

  @override
  List<Object?> get props => [malId, imageUrl, title, titleEnglish,season,year];
}
