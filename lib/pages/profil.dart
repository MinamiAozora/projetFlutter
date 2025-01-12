import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:tp1/components/post.dart';
import 'package:tp1/models/postmodel.dart';
import '../services/weather_service.dart'; // Importer le service météo
import '../services/location_service.dart'; // Importer le service de localisation

class Profil extends StatelessWidget {
  final String idUser; // Utilisateur passé en paramètre par son UID

  Profil({required this.idUser});

  @override
  Widget build(BuildContext context) {
    final currentidUser = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'UID de l'utilisateur authentifié

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${idUser}'),
        actions: [
          if (currentidUser == idUser) // Vérifie si c'est l'utilisateur actuel
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Logique pour éditer les informations personnelles
                _showEditProfileDialog(context, idUser);
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
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('User').doc(idUser).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // Affiche un loader tant que les données ne sont pas chargées
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final String name = userData['name'];
                  final String photo = userData['photo'];
                  final String city = userData['city'];
                  final String country = userData['country'];
                  final String phoneNumber = userData['phoneNumber'];
                  final String birthday = userData['birthday'];

                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(photo),
                        radius: 80,
                      ),
                      SizedBox(height: 20),
                      Text(
                        name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text('Ville: $city', style: TextStyle(fontSize: 16)),
                      Text('Pays: $country', style: TextStyle(fontSize: 16)),
                      Text('Numéro de téléphone: $phoneNumber', style: TextStyle(fontSize: 16)),
                      Text('Anniversaire: $birthday', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      if (currentidUser == idUser) // Si c'est l'utilisateur actuel, afficher le bouton pour ajouter un post
                        ElevatedButton(
                          onPressed: () {
                            // Logique pour ajouter un post
                            _showAddPostDialog(context);
                          },
                          child: Text('Ajouter un Post'),
                        ),
                    ],
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Post')
                      .where('idUser', isEqualTo: idUser) // Filtrer par idUser
                      .orderBy('timestamp', descending: true) // Tri des posts par timestamp
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    
                    final posts = snapshot.data!.docs;
                    List<Widget> postWidgets = [];

                    for (var post in posts) {
                      final idPost = post.id; // Nous récupérons uniquement l'ID du post
                      postWidgets.add(Post(idPost: idPost)); // Passer l'ID à la classe Post
                    }

                    return ListView(
                      children: postWidgets,
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
  void _showEditProfileDialog(BuildContext context, String idUser) {
    TextEditingController nameController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController countryController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
    TextEditingController photoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                controller: countryController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
              ),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(labelText: 'Date de naissance'),
              ),
              TextField(
                controller: photoController,
                decoration: InputDecoration(labelText: 'URL de la photo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('User')
                      .doc(idUser)
                      .update({
                    'name': nameController.text,
                    'city': cityController.text,
                    'country': countryController.text,
                    'phoneNumber': phoneController.text,
                    'birthday': birthdayController.text,
                    'photo': photoController.text,
                  });

                  Navigator.pop(context);
                } catch (e) {
                  print('Erreur lors de la mise à jour du profil: $e');
                  Navigator.pop(context);
                }
              },
              child: Text('Sauvegarder'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // Dialog pour ajouter un post avec météo
  void _showAddPostDialog(BuildContext context) {
    TextEditingController postTextController = TextEditingController();
    TextEditingController postImageController = TextEditingController();
    final LocationService locationService = LocationService();
    final WeatherService weatherService = WeatherService();

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
              onPressed: () async {
                try {
                  final position = await locationService.getCurrentLocation();
                  final city = await locationService.getCityFromCoordinates(position);
                  final weatherData = await weatherService.fetchWeatherData(city);
                  final temperature = (weatherData['main']['temp'] - 273.15).round();
                  final weather = weatherData['weather'][0]['main'];

                  final newPost = Postmodel(
                    image: postImageController.text,
                    text: postTextController.text,
                    city: city,
                    temperature: temperature,
                    weather: weather,
                  );

                  FirebaseFirestore.instance.collection('Post').add({
                    'idUser': FirebaseAuth.instance.currentUser!.uid,
                    'text': newPost.text,
                    'image': newPost.image,
                    'city': newPost.city,
                    'temperature': newPost.temperature,
                    'weather': newPost.weather,
                    'commentaire': 0,
                    'like': 0,
                    'share': 0,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                } catch (e) {
                  print('Erreur: $e');
                  Navigator.pop(context);
                }
              },
              child: Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
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
