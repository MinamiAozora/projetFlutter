import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importer Firebase Auth

class Recherche extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController _searchController = TextEditingController();

  // Fonction de recherche
  void _performSearch(BuildContext context) async {
  String query = _searchController.text;

  if (query.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez entrer un texte pour rechercher')),
    );
    return;
  }

  try {
    // Rechercher un utilisateur dans la collection `users`
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users') // Nom de la collection
        .where('id', isEqualTo: query) // Rechercher un utilisateur par ID
        .get();

    if (userSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aucun utilisateur trouvé avec cet ID')),
      );
      return;
    }

    // Récupérer les informations de l'utilisateur trouvé
    final foundUser = userSnapshot.docs.first;
    final String foundUserId = foundUser['id'];
    final String foundUserName = foundUser['name'] ?? 'Utilisateur inconnu'; // Nom de l'utilisateur trouvé
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String currentUserName = FirebaseAuth.instance.currentUser?.displayName ?? 'Vous'; // Nom de l'utilisateur actuel

    if (foundUserId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous ne pouvez pas vous ajouter en ami')),
      );
      return;
    }

    // Vérifier si l'ami est déjà ajouté
    final currentUserFriendRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(foundUserId);

    final friendExists = await currentUserFriendRef.get();
    if (friendExists.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cet utilisateur est déjà votre ami')),
      );
      return;
    }

    // Créer une conversation privée dans la collection `Conversation`
    final conversationRef = FirebaseFirestore.instance.collection('Conversation').doc();
    await conversationRef.set({
      'participants': [currentUserId, foundUserId], // Liste des participants
      'titre': 'Conversation entre $currentUserName et $foundUserName', // Titre de la conversation
      'createdAt': FieldValue.serverTimestamp(), // Timestamp de création
    });

    final String conversationId = conversationRef.id; // Récupérer l'ID de la conversation créée

    // Ajouter l'ami et la référence à la conversation dans la sous-collection `friends`
    await currentUserFriendRef.set({
      'id': foundUserId,
      'idPrivateMessage': conversationId, // ID de la conversation privée
      'addedAt': FieldValue.serverTimestamp(),
    });

    final foundUserFriendRef = FirebaseFirestore.instance
        .collection('users')
        .doc(foundUserId)
        .collection('friends')
        .doc(currentUserId);

    await foundUserFriendRef.set({
      'id': currentUserId,
      'idPrivateMessage': conversationId, // ID de la conversation privée
      'addedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Utilisateur ajouté en ami et conversation créée')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Une erreur est survenue : ${e.toString()}')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Container(
            width: 400,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un utilisateur...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(context), // Effectuer la recherche et ajouter un ami
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Définit la hauteur de l'AppBar
}
