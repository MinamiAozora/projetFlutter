import 'package:flutter/material.dart';
import '../models/messagemodel.dart';
import '../models/usermodel.dart';
import 'profil.dart';
class Chat extends StatefulWidget {
  final Usermodel user; // L'utilisateur passé en paramètre

  Chat({required this.user});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();

  // Fonction pour envoyer un message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        widget.user.messages.add(Messagemodel(
          sender: 'Me',
          content: _controller.text,
          isMine: true,
        ));
        _controller.clear(); // Efface le champ de texte
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat avec ${widget.user.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.photo),
            radius: 40,
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user.messages.length,
              itemBuilder: (context, index) {
                final message = widget.user.messages[index];
                bool isMine = message.isMine;

                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMine ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Écrivez un message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
