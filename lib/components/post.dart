import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1/models/postmodel.dart';
import 'package:tp1/providers/userprovider.dart';
import 'interactions/commentaire.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final Postmodel postmodel;


  Post({
    required this.postmodel,
  });

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  late Postmodel _postmodel;

  @override
  void initState() {
    super.initState();
    // Initialiser les variables d'état avec les valeurs du widget
    _postmodel = widget.postmodel;
  }
  void incrementLike() {
    setState(() {
      _postmodel.like++;
    });
  }

  void addComment(String comment) {
    setState(() {
      _postmodel.commentaires.add(comment);
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
                image: NetworkImage(_postmodel.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 10),
          // Informations sur le lieu, température et météo
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 20),
              Text(
                '${_postmodel.city}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Icon(Icons.thermostat_outlined, color: Colors.orange, size: 20),
              Text(
                '${_postmodel.temperature}°C',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 10),
              Icon(Icons.wb_sunny_outlined, color: Colors.yellow, size: 20),
              Text(
                '${_postmodel.weather}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Texte du post
          Text(
            _postmodel.text,
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
                  Text('${_postmodel.like}'), // Compteur de likes
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
                            commentaires: _postmodel.commentaires,
                            addComment: addComment,
                          ),
                        ),
                      );
                    },
                  ),
                  Text('${_postmodel.commentaires.length}'), // Compteur de commentaires
                ],
              ),
              // Bouton Partage avec compteur
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: Colors.blue),
                    onPressed: () {
                      // Appel au Provider
                      final userProvider = Provider.of<UserProvider>(context, listen: false);

                      userProvider.sharePost(userProvider.currentUser,_postmodel);

                      // Met à jour le compteur local pour afficher immédiatement le changement
                    },
                  ),
                  Text('${_postmodel.partage}'), // Compteur de partages
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