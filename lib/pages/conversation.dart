import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'chat.dart';

class Conversation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Conversation')
          .where('participants', arrayContains: currentUserUid) // Filtrer par participants
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un loader si on attend une réponse
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Gérer les erreurs éventuelles
          return Center(child: Text("Erreur lors du chargement des données."));
        }

        // Si les données sont reçues mais qu'elles sont vides
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucune conversation trouvée.'));
        }
        final conversations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: conversations.length, // Liste des conversations
          itemBuilder: (context, index) {
            final conversation = conversations[index];

            return ListTile(
              leading: Icon(Icons.chat, color: Colors.blue), // Icône pour les conversations
              title: Text(conversation['titre'] ?? 'Sans titre'), // Titre de la conversation
              onTap: () {
                // Navigation vers la page de chat avec l'ID de la conversation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      idConversation: conversation.id, // Passage de l'ID de la conversation en paramètre
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
