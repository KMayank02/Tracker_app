import 'package:equatable/equatable.dart';

class AnimeTile extends Equatable {
  late int malId;
  late String imageUrl;
  late String title;
  late String titleEnglish;

  AnimeTile({
    this.malId = 0,
    this.imageUrl = '',
    this.title = '',
    this.titleEnglish = '',
  });

  factory AnimeTile.fromJson(Map<String, dynamic> json) {

    return AnimeTile(
      malId: json['mal_id'] ?? 0,
      imageUrl: json['images']['jpg']['large_image_url'] ?? '',
      title: json['title'] ?? '',
      titleEnglish: json['title_english'] ?? 'TBA',
    );
  }

  @override
  List<Object?> get props => [malId, imageUrl, title, titleEnglish];
}
