class Relation {
  late String relationName;
  late int malId;
  late String url;
  late String imageUrl;
  late String title;
  late String titleEnglish;

  Relation({
    this.relationName = '',
    this.malId = 0,
    this.imageUrl = '',
    this.title = '',
    this.titleEnglish = '',
  });

  factory Relation.fromJson(Map<String, dynamic> json) {

    return Relation(
      malId: json['mal_id'] ?? 0,
      imageUrl: json['images']['jpg']['image_url'] ?? '',
      title: json['title'] ?? '',
      titleEnglish: json['title_english'] ?? 'TBA',
    );
  }
}
