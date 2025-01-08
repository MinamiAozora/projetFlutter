import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:tp1/providers/userprovider.dart';
import '../models/usermodel.dart';
import 'chat.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer correctement UserProvider

class Conversation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Accès au UserProvider
    Usermodel currentUser = userProvider.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversation')
          .where('participants', arrayContains: currentUser.id) // Filtrer par participants
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Afficher un loader pendant le chargement
        }

        final conversations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: conversations.length, // Liste des conversations
          itemBuilder: (context, index) {
            final conversation = conversations[index];

            return ListTile(
              leading: Icon(Icons.chat, color: Colors.blue), // Icône pour les conversations
              title: Text(conversation['title'] ?? 'Sans titre'), // Titre de la conversation
              onTap: () {
                // Navigation vers la page de chat avec l'ID de la conversation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      conversationId: conversation.id, // Passage de l'ID de la conversation en paramètre
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
