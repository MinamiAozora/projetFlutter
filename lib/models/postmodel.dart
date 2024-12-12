

class Postmodel {
  final String image;
  final String text;
  int like;
  int partage;
  List<String> commentaires;

  Postmodel({
    required this.image,
    required this.text,
    this.like = 0,
    this.partage = 0,
    this.commentaires = const [],
  });
}
