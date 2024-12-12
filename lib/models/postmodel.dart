class Postmodel {
  final String image;
  final String text;
  int like;
  int partage;
  final String city;
  final int temperature;
  final String weather;
  List<String> commentaires;

  Postmodel({
    required this.image,
    required this.text,
    required this.city,
    required this.temperature,
    required this.weather,
    this.like = 0,
    this.partage = 0,
    this.commentaires = const [],
  });
}
