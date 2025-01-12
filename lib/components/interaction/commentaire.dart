import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Commentaire extends StatefulWidget {
  final String idPost;

  Commentaire({required this.idPost});

  @override
  _CommentaireState createState() => _CommentaireState();
}

class _CommentaireState extends State<Commentaire> {
  late TextEditingController _commentController;
  late bool _isLoading;
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _isLoading = true;
    _fetchComments();
  }

  // Récupérer les commentaires pour un post spécifique
  void _fetchComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Commentaire')
          .where('idPost', isEqualTo: widget.idPost)
          .orderBy('timestamp', descending: false)
          .get();

      setState(() {
        _comments = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur lors de la récupération des commentaires: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Ajouter un nouveau commentaire
  void _addComment() async {
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String commentText = _commentController.text.trim();

    if (commentText.isNotEmpty) {
      try {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('Commentaire')
            .add({
          'idPost': widget.idPost,
          'idUser': currentUserUid,
          'text': commentText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        
        await FirebaseFirestore.instance
          .collection('Post')
          .doc(widget.idPost)
          .update({
        'commentaire': FieldValue.increment(1),
      });
      } catch (error) {
        print('Erreur lors de l\'ajout du commentaire: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Liste des commentaires
                Expanded(
                  child: ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return ListTile(
                        title: Text(comment['text']),
                        subtitle: Text('Utilisateur: ${comment['idUser']}'),
                        trailing: Text(
                          (comment['timestamp'] as Timestamp)
                              .toDate()
                              .toString()
                              .substring(0, 16), // Afficher une date formatée
                        ),
                      );
                    },
                  ),
                ),
                // Champ d'ajout de commentaire
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: 'Ajouter un commentaire...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
