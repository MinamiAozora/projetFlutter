import 'package:flutter/material.dart';
import 'package:tp1/components/post.dart';
import 'package:provider/provider.dart';
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
                child: ListView.builder(
                  itemCount: user.posts.length,
                  itemBuilder: (context, index) {
                    final post = user.posts[index];
                    return Post(
                      image: post.image,
                      text: post.text,
                      like: post.like,
                      partage: post.partage,
                      city: post.city,
                      temperature: post.temperature,
                      weather: post.weather,
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
                  print(position.latitude.toString()+' '+position.longitude.toString()+' '+position.altitude.toString());
                  // Obtenir la ville à partir des coordonnées
                  final city = await locationService.getCityFromCoordinates(position);
                  print(city);
                  // Obtenir les données météo pour cette ville
                  final weatherData = await weatherService.fetchWeatherData(city);
                  print(weatherData['main']['temp']);
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

                  // Ajouter le post
                  userProvider.addPost(userProvider.currentUser, newPost);

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
