import 'package:flutter/material.dart';
import 'package:tp1/components/post.dart';
import 'package:provider/provider.dart';
import 'package:tp1/models/postmodel.dart';
import '../models/usermodel.dart';
import '../providers/userprovider.dart'; // Importer UserProvider

class Profil extends StatelessWidget {
  final Usermodel user; // L'utilisateur passé en paramètre

  Profil({required this.user});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isCurrentUser = user == userProvider.currentUser; // Vérifie si l'utilisateur est le même que l'utilisateur actuel

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${user.name}'),
        actions: [
          if (isCurrentUser) // Afficher les actions si c'est l'utilisateur actuel
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Logique pour éditer les informations personnelles (exemple)
                _showEditProfileDialog(context, userProvider.currentUser);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photo),
                radius: 80,
              ),
              SizedBox(height: 20),
              Text(
                user.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text('Ville: ${user.city}', style: TextStyle(fontSize: 16)),
              Text('Pays: ${user.country}', style: TextStyle(fontSize: 16)),
              Text('Numéro de téléphone: ${user.phoneNumber}', style: TextStyle(fontSize: 16)),
              Text('Anniversaire: ${user.birthday}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              if (isCurrentUser) // Si c'est l'utilisateur actuel, afficher le bouton pour ajouter un post
                ElevatedButton(
                  onPressed: () {
                    // Logique pour ajouter un post (exemple)
                    _showAddPostDialog(context, userProvider);
                  },
                  child: Text('Ajouter un Post'),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: user.posts.length,
                  itemBuilder: (context, index) {
                    final post = user.posts[index];
                    return Post(
                      image: post.image,
                      text: post.text,
                      like: post.like,
                      partage: post.partage,
                      commentaires: post.commentaires,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog pour éditer les informations de profil
  void _showEditProfileDialog(BuildContext context, Usermodel user) {
    // Afficher un dialog pour éditer les informations de profil (exemple)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: user.name);
        TextEditingController cityController = TextEditingController(text: user.city);
        TextEditingController phoneController = TextEditingController(text: user.phoneNumber);

        return AlertDialog(
          title: Text('Modifier Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Appliquer les modifications
                user.name = nameController.text;
                user.city = cityController.text;
                user.phoneNumber = phoneController.text;

                // Fermer le dialog
                Navigator.pop(context);
              },
              child: Text('Sauvegarder'),
            ),
            TextButton(
              onPressed: () {
                // Annuler les modifications
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour ajouter un post
  void _showAddPostDialog(BuildContext context, UserProvider userProvider) {
    TextEditingController postTextController = TextEditingController();
    TextEditingController postImageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: postTextController,
                decoration: InputDecoration(labelText: 'Texte du Post'),
              ),
              TextField(
                controller: postImageController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Créer un nouveau post et l'ajouter à la liste des posts de l'utilisateur
                final newPost = Postmodel(
                  image: postImageController.text,
                  text: postTextController.text,
                  like: 0,
                  partage: 0,
                  commentaires: [],
                );

                userProvider.addPost(userProvider.currentUser, newPost);

                // Fermer le dialog
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
                // Annuler l'ajout du post
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}
