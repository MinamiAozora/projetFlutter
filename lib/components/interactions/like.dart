import 'package:flutter/material.dart';

class Like extends StatefulWidget {
  @override
  _LikeState createState() => _LikeState();
}

class _LikeState extends State<Like> {
  int _likeCount = 0; // Initialisation du compteur de likes

  void _incrementLike() {
    setState(() {
      _likeCount++; // Incrémente le compteur
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // S'adapte au contenu
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
          onPressed: _incrementLike, // Appel à la fonction pour incrémenter
        ),
        Text(
          '$_likeCount', // Affiche le compteur
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
