import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth to get current user's UID
import 'profil.dart';

class Chat extends StatefulWidget {
  final String idConversation; // L'ID de la conversation

  Chat({required this.idConversation});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String _currentUserId; // Utilisateur actuel récupéré depuis Firebase
  final TextEditingController _controller = TextEditingController();
  late Stream<QuerySnapshot> _messagesStream; // Stream pour récupérer les messages

  @override
  void initState() {
    super.initState();

    // Get the current user's UID from Firebase Authentication
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    _messagesStream = FirebaseFirestore.instance
        .collection('Message')
        .where('idConversation', isEqualTo: widget.idConversation)
        .orderBy('time', descending: false) // Trie les messages par timestamp croissant
        .snapshots();
    
  }

  // Fonction pour envoyer un message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('Message').add({
        'idConversation': widget.idConversation,
        'idUser': _currentUserId,
        'text': _controller.text,
        'time': FieldValue.serverTimestamp(),
      });
      _controller.clear(); // Efface le champ de texte
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(idUser: _currentUserId), // Pass the idUser instead of the whole user
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Afficher l'image de profil de l'utilisateur actuel
          CircleAvatar(
            backgroundImage: NetworkImage('URL or placeholder for current user profile photo'),
            radius: 40,
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageData = message.data() as Map<String, dynamic>;
                  final String text = messageData['text'];
                  final String idUser = messageData['idUser'];
                  final bool isMine = idUser == _currentUserId;

                  messageWidgets.add(
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('User')
                          .doc(idUser)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox.shrink(); // Chargement de l'image et des informations
                        }

                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        final String userName = userData['name'];
                        final String userPhoto = userData['photo'];

                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              // Naviguer vers la page de profil de l'utilisateur
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profil(idUser: idUser), // Pass the idUser to the Profil page
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMine ? Colors.blue[300] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Affichage du nom de l'utilisateur au-dessus du message
                                  Text(
                                    userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isMine ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(userPhoto),
                                    radius: 20,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    text,
                                    style: TextStyle(
                                      color: isMine ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Écrivez un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
