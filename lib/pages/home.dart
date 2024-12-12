import 'package:flutter/material.dart';
import 'package:tp1/providers/userprovider.dart';
import 'chat.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer correctement UserProvider

class Home extends StatelessWidget {
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

    return ListView.builder(
      itemCount: userProvider.users.length, // Liste des utilisateurs
      itemBuilder: (context, index) {
        final user = userProvider.users[index];

        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photo), // Photo de profil
                radius: 25,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: getStatusColor(user.status), // Couleur du statut
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              if (user.notifications > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${user.notifications}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(user.name),
          subtitle: Text(user.messages.isNotEmpty
              ? user.messages.last.content
              : ' '), // Dernier message de l'utilisateur
          onTap: () {
            // Navigation vers la page de chat avec l'ami sélectionné
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  user: user, // Passage de l'utilisateur en paramètre
                ),
              ),
            );
          },
        );
      },
    );
  }
}
