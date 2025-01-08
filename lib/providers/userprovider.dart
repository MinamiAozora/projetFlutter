import 'package:flutter/material.dart';
import '../models/usermodel.dart';

class UserProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Usermodel _currentUser = Usermodel(
  id:'test',
  name: 'Hank',
  photo: 'https://via.placeholder.com/150',
  status: 'busy',
  phoneNumber: '01 77 66 55 44',
  city: 'Strasbourg',
  country: 'France',
  birthday: '25/12/1987',
);

  // Getter et Setter pour l'utilisateur actuel
  Usermodel get currentUser => _currentUser;

  set currentUser(Usermodel user) {
    _currentUser = user;
    notifyListeners();  // Notifie les widgets écoutant ce changement
  }

  // Ajouter un utilisateur
  void addUser(Usermodel user) {
    
    notifyListeners();
  }

}
