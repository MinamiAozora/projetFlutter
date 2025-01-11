import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'chat.dart';

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
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserUid)  // Utilisation de l'ID de l'utilisateur connecté
          .collection('friends')  // Accès à la sous-collection "friends"
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un loader si on attend une réponse
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur lors du chargement des données."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Aucune donnée disponible."));
        }

        final friends = snapshot.data!.docs;

        return ListView.builder(
          itemCount: friends.length, // Liste des amis
          itemBuilder: (context, index) {
            final friendId = friends[index].id;  // L'ID de l'ami
            final idConversation = friends[index]['idPrivateMessage'];
            // Cherche les informations de l'ami dans la collection User
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('User')
                  .doc(friendId) // Utilisation de l'ID de l'ami pour récupérer ses données
                  .get(),
              builder: (context, friendSnapshot) {
                if (friendSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (friendSnapshot.hasError) {
                  return Center(child: Text("Erreur lors du chargement des informations de l'ami."));
                }

                if (!friendSnapshot.hasData || friendSnapshot.data == null) {
                  return Center(child: Text("Aucune donnée disponible pour cet ami."));
                }

                final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;
                final friendName = friendData['name'] ?? 'Nom inconnu';
                final friendStatus = friendData['status'] ?? 'offline';
                final friendPhoto = friendData['photo'] ?? '';

                return GestureDetector(
                  onTap: () {
                     // Utilisation de l'ID de la conversation déjà pré-créée

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          idConversation: idConversation,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: friendPhoto.isNotEmpty
                                  ? NetworkImage(friendPhoto)
                                  : null,
                              radius: 25,
                              child:
                                  friendPhoto.isEmpty ? Icon(Icons.person) : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: getStatusColor(friendStatus),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friendName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              friendStatus,
                              style: TextStyle(
                                fontSize: 14,
                                color: getStatusColor(friendStatus),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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
