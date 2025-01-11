import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tp1/firebase_options.dart';
import 'pages/conversation.dart';
import 'components/recherche.dart';
import 'pages/friend.dart';
import 'pages/login.dart';
import 'pages/profil.dart'; // Importation de la page de connexion.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    
    MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversation',
      home: AuthenticationWrapper(), // Vérifie si l'utilisateur est connecté.
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Chargement en cours.
        } else if (snapshot.hasData) {
          // L'utilisateur est connecté.
          return HomePage(); // La page principale.
        } else {
          // L'utilisateur n'est pas connecté.
          return LoginPage();
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Conversation(),
    Friend(),
    Profil(idUser: FirebaseAuth.instance.currentUser?.uid ?? ''),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Recherche(), // AppBar personnalisée
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Amis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
