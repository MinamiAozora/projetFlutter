import 'package:flutter/material.dart';

class Commentaire extends StatelessWidget {
  final List<String> commentaires;
  final Function(String) addComment;

  Commentaire({required this.commentaires, required this.addComment});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Commentaires"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: commentaires.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(commentaires[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      addComment(commentController.text);
                      commentController.clear();
                      Navigator.pop(context); // Retour à la page précédente
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
