import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userprovider.dart'; // Importer votre UserProvider
import '../models/usermodel.dart'; // Importer le modèle User

class Recherche extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController _searchController = TextEditingController();

  // Fonction de recherche
  void _performSearch(BuildContext context) {
    String query = _searchController.text;
    if (query.isEmpty) {
      // Afficher un message si la recherche est vide
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un texte pour rechercher')),
      );
    } else {
      // Créer un nouvel utilisateur avec le nom de recherche
      final newUser = Usermodel(
        name: query,
        photo: 'null',  // Vous pouvez mettre une URL vide ou par défaut
        city: 'somewhere',  // Si vous avez d'autres propriétés comme la ville, vous pouvez les initialiser à vide
        country: 'somewhere',
        phoneNumber: '00 00 00 00 00',
        birthday: '00/00/0000',
        status: 'busy',
        id:'0',
      );

      // Ajouter cet utilisateur à la liste des utilisateurs dans le Provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.addUser(newUser);

      // Afficher un message confirmant l'ajout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur "${query}" ajouté')),
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
                      hintText: 'Rechercher...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(context), // Effectuer la recherche et ajouter un utilisateur
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
