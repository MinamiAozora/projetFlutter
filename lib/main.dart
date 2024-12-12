import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'components/navbar.dart';
import 'components/recherche.dart';
import 'providers/userprovider.dart';
void main() {
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
      title: 'Home',
      home:Scaffold(
        appBar: Recherche(),
        body: Home(),
        bottomNavigationBar: Navbar(),
      ),
    );
  }
}