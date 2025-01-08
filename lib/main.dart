import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1/firebase_options.dart';
import 'pages/conversation.dart';
import 'components/navbar.dart';
import 'components/recherche.dart';
import 'providers/userprovider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversation',
      home:Scaffold(
        appBar: Recherche(),
        body: Conversation(),
        bottomNavigationBar: Navbar(),
      ),
    );
  }
}