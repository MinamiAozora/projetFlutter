import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'interaction/commentaire.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final String idPost; // Prendre uniquement l'idPost en paramètre

  Post({
    required this.idPost,
  });

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  late Map<String, dynamic> _postData; // Variable pour stocker les données du post
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchPostData();
  }

  // Fonction pour récupérer les données du post à partir de Firebase
  void _fetchPostData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.idPost)
          .get();
      
      if (snapshot.exists) {
        setState(() {
          _postData = snapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Erreur de récupération du post: $error');
    }
  }

  // Fonction pour incrémenter le like dans Firebase
  void incrementLike() async {
    try {
      await FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.idPost)
          .update({
        'like': FieldValue.increment(1),
      });
    } catch (error) {
      print('Erreur lors de l\'incrémentation du like: $error');
    }
  }

  // Fonction pour sharer un post (copier l'image et le texte dans les posts de l'utilisateur)
  void sharePost() async {
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    try {
      await FirebaseFirestore.instance.collection('Post').add({
        'text': _postData['text'],
        'image': _postData['image'],
        'city': _postData['city'],
        'temperature': _postData['temperature'],
        'weather': _postData['weather'],
        'commentaire': 0,
        'userId': currentUserUid,
        'like': 0, // Le post partagé commence avec 0 likes
        'share': 0, // Le post partagé commence avec 0 shares
      });
      await FirebaseFirestore.instance.collection('Post').doc(widget.idPost).update({
      'share': FieldValue.increment(1),
    });
    } catch (error) {
      print('Erreur lors du share du post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
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
                        image: NetworkImage(_postData['image']),
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
                        '${_postData['city']}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.thermostat_outlined, color: Colors.orange, size: 20),
                      Text(
                        '${_postData['temperature']}°C',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.wb_sunny_outlined, color: Colors.yellow, size: 20),
                      Text(
                        '${_postData['weather']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Texte du post
                  Text(
                    _postData['text'],
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
                          Text('${_postData['like']}'), // Compteur de likes
                        ],
                      ),
                      // Bouton Commentaire avec compteur (on garde ce bouton pour navigation vers commentaires)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.comment_outlined, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Commentaire(idPost: widget.idPost),
                                ),
                              );
                            },

                          ),
                          Text('${_postData['commentaire']?.length ?? 0}'), // Compteur de commentaires
                        ],
                      ),
                      // Bouton share avec compteur
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.share_outlined, color: Colors.blue),
                            onPressed: sharePost,
                          ),
                          Text('${_postData['share']}'), // Compteur de shares
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
