import 'package:flutter/material.dart';
import 'interactions/commentaire.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final String image;
  final String text;
  int like;
  int partage;
  List<String> commentaires;

  Post({
    required this.image,
    required this.text,
    required this.like,
    required this.partage,
    required this.commentaires,
  });

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  void incrementLike() {
    setState(() {
      widget.like++;
    });
  }

  void incrementPartage() {
    setState(() {
      widget.partage++;
    });
  }

  void addComment(String comment) {
    setState(() {
      widget.commentaires.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 10),
            // Texte du post
            Text(
              widget.text,
              style: TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            // Icons et compteurs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bouton Like avec compteur
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
                      onPressed: incrementLike,
                    ),
                    Text('${widget.like}'), // Compteur de likes
                  ],
                ),
                // Bouton Commentaire avec compteur
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment_outlined, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Commentaire(
                              commentaires: widget.commentaires,
                              addComment: addComment,
                            ),
                          ),
                        );
                      },
                    ),
                    Text('${widget.commentaires.length}'), // Compteur de commentaires
                  ],
                ),
                // Bouton Partage avec compteur
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.blue),
                      onPressed: incrementPartage,
                    ),
                    Text('${widget.partage}'), // Compteur de partages
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
