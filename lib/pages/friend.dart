import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:tp1/providers/userprovider.dart';
import '../models/usermodel.dart';
import 'chat.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer correctement UserProvider

class Friend extends StatelessWidget {
  // Fonction pour obtenir la couleur en fonction du statut
  Color getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Accès au UserProvider
    Usermodel currentUser = userProvider.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Afficher un loader pendant le chargement
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final friends = userData['friends'] as List<dynamic>? ?? [];

        return ListView.builder(
          itemCount: friends.length, // Liste des amis
          itemBuilder: (context, index) {
            final friendId = friends[index];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(friendId)
                  .get(),
              builder: (context, friendSnapshot) {
                if (!friendSnapshot.hasData) {
                  return ListTile(
                    title: Text('Chargement...'),
                  );
                }

                final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;
                final friendName = friendData['name'] ?? 'Nom inconnu';
                final friendStatus = friendData['status'] ?? 'offline';
                final friendPhoto = friendData['photo'] ?? '';

                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: friendPhoto.isNotEmpty
                            ? NetworkImage(friendPhoto)
                            : null,
                        radius: 25,
                        child: friendPhoto.isEmpty ? Icon(Icons.person) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: getStatusColor(friendStatus), // Couleur du statut
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(friendName),
                  subtitle: Text(
                    friendStatus, // Statut en toutes lettres
                    style: TextStyle(
                      color: getStatusColor(friendStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    // Chercher ou créer une conversation avec uniquement currentUser et friend
                    final conversationQuery = await FirebaseFirestore.instance
                        .collection('conversation')
                        .where('participants', arrayContains: currentUser.id)
                        .get();

                    String conversationId;
                    final existingConversation = conversationQuery.docs.firstWhere(
                      (doc) {
                        final participants = List<String>.from(doc['participants'] ?? []);
                        return participants.contains(friendId) &&participants.contains(currentUser.id)&& participants.length == 2;
                      },
                    );

                    if (existingConversation.data().isNotEmpty) {
                      conversationId = existingConversation.id;
                    } else {
                      final newConversation = await FirebaseFirestore.instance
                          .collection('conversation')
                          .add({
                        'participants': [currentUser.id, friendId],
                        'titre': "Conversation entre "+friendName+" et "+userData['name'],
                      });
                      conversationId = newConversation.id;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          conversationId: conversationId, // Passage de l'ID de la conversation en paramètre
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
