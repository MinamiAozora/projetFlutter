import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1/components/post.dart';
import 'package:tp1/models/postmodel.dart';
import '../models/usermodel.dart';
import '../providers/userprovider.dart'; // Importer UserProvider
import '../services/weather_service.dart'; // Importer le service météo
import '../services/location_service.dart'; // Importer le service de localisation

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
                    // Logique pour ajouter un post
                    _showAddPostDialog(context, userProvider);
                  },
                  child: Text('Ajouter un Post'),
                ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('idUser', isEqualTo: user.id) // Filtrer par idUser
                      .orderBy('timestamp', descending: true) // Tri des posts par timestamp (les plus récents en premier)
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
  void _showEditProfileDialog(BuildContext context, Usermodel user) {
  // Initialisation des contrôleurs avec les données actuelles de l'utilisateur
  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController cityController = TextEditingController(text: user.city);
  TextEditingController countryController = TextEditingController(text: user.country);
  TextEditingController phoneController = TextEditingController(text: user.phoneNumber);
  TextEditingController birthdayController = TextEditingController(text: user.birthday);
  TextEditingController photoController = TextEditingController(text: user.photo); // Ajouter le champ photo

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
              // Mise à jour des informations dans Firebase
              try {
                // Mise à jour dans Firebase
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id) // Utilisez l'ID de l'utilisateur pour cibler le document
                    .update({
                      'name': nameController.text,
                      'city': cityController.text,
                      'country': countryController.text,
                      'phoneNumber': phoneController.text,
                      'birthday': birthdayController.text,
                      'photo': photoController.text, // Mise à jour du champ photo
                    });

                // Appliquer les modifications localement
                user.name = nameController.text;
                user.city = cityController.text;
                user.country = countryController.text;
                user.phoneNumber = phoneController.text;
                user.birthday = birthdayController.text;
                user.photo = photoController.text; // Mettre à jour la photo localement

                // Fermer le dialog
                Navigator.pop(context);
              } catch (e) {
                // Gérer les erreurs
                print('Erreur lors de la mise à jour du profil: $e');
                Navigator.pop(context);
              }
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


  // Dialog pour ajouter un post avec météo
  void _showAddPostDialog(BuildContext context, UserProvider userProvider) {
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
                  // Obtenir la position actuelle
                  final position = await locationService.getCurrentLocation();
                  // Obtenir la ville à partir des coordonnées
                  final city = await locationService.getCityFromCoordinates(position);
                  // Obtenir les données météo pour cette ville
                  final weatherData = await weatherService.fetchWeatherData(city);
                  // Extraire les informations météo
                  final temperature = (weatherData['main']['temp'] - 273.15).round();
                  final weather = weatherData['weather'][0]['main'];

                  // Créer un nouveau post
                  final newPost = Postmodel(
                    image: postImageController.text,
                    text: postTextController.text,
                    city: city,
                    temperature: temperature,
                    weather: weather,
                  );

                  // Ajouter le post dans Firebase
                  FirebaseFirestore.instance.collection('posts').add({
                    'idUser': userProvider.currentUser.id,
                    'text': newPost.text,
                    'image': newPost.image,
                    'city': newPost.city,
                    'temperature': newPost.temperature,
                    'weather': newPost.weather,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Fermer le dialog
                  Navigator.pop(context);
                } catch (e) {
                  // Gérer les erreurs
                  print('Erreur: $e');
                  Navigator.pop(context);
                }
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
