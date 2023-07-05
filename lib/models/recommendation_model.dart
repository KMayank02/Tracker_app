import 'package:equatable/equatable.dart';

class RecommendationTile extends Equatable {
  late int malId;
  late String imageUrl;
  late String title;

  RecommendationTile({
    this.malId = 0,
    this.imageUrl = '',
    this.title = '',
  });

  factory RecommendationTile.fromJson(Map<String, dynamic> json) {

    return RecommendationTile(
      malId: json['entry']['mal_id'] ?? 0,
      imageUrl: json['entry']['images']['jpg']['large_image_url'] ?? '',
      title: json['entry']['title'] ?? 'TBA',
    );
  }

  @override
  List<Object?> get props => [malId, imageUrl, title];
}
