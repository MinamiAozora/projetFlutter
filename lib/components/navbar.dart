import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assurez-vous d'importer Provider
import 'package:tp1/pages/profil.dart'; // Assurez-vous d'importer votre page de profil
import 'package:tp1/providers/userprovider.dart';

import '../models/usermodel.dart'; // Importer le UserProvider

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur actuel à partir du UserProvider
    Usermodel currentUser = Provider.of<UserProvider>(context).currentUser;

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      onTap: (index) {
        // Action à effectuer lorsqu'on clique sur un bouton
        switch (index) {
          case 0:
            print('Accueil sélectionné');
            break;
          case 1:
            // Vérifier si currentUser est nul avant de naviguer
            
              // Naviguer vers la page de profil avec les informations de currentUser
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profil(user:currentUser)),
              );
            
            break;
          case 2:
            print('Paramètres sélectionnés');
            break;
        }
      },
    );
  }
}
