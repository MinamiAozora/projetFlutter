import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usermodel.dart';
import '../providers/userprovider.dart';
import 'profil.dart';

class Chat extends StatefulWidget {
  final String conversationId; // L'ID de la conversation

  Chat({required this.conversationId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Usermodel _currentUser; // Utilisateur actuel récupéré via le UserProvider
  final TextEditingController _controller = TextEditingController();
  late Stream<QuerySnapshot> _messagesStream; // Stream pour récupérer les messages

  @override
  void initState() {
    super.initState();
    _currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    _messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('conversationId', isEqualTo: widget.conversationId)
        .orderBy('time', descending: false) // Trie les messages par timestamp croissant
        .snapshots();
  }

  // Fonction pour envoyer un message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'conversationId': widget.conversationId,
        'idUser': _currentUser.id,
        'content': _controller.text,
        'time': FieldValue.serverTimestamp(),
      });
      _controller.clear(); // Efface le champ de texte
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(user: _currentUser),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Afficher l'image de profil de l'utilisateur actuel
          CircleAvatar(
            backgroundImage: NetworkImage(_currentUser.photo),
            radius: 40,
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageData = message.data() as Map<String, dynamic>;
                  final String content = messageData['content'];
                  final String idUser = messageData['idUser'];
                  final Timestamp time = messageData['time'];
                  final bool isMine = idUser == _currentUser.id;

                  messageWidgets.add(
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(idUser)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox.shrink(); // Chargement de l'image et des informations
                        }
                        
                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        final String userName = userData['name'];
                        final String userPhoto = userData['photo'];
                        final String userCity = userData['city'];
                        final String userCountry = userData['country'];
                        final String userPhoneNumber = userData['phoneNumber'];
                        final String userBirthday = userData['birthday'];
                        final String userStatus = userData['status'];
                        final String userId = userSnapshot.data!.id; // ID de l'utilisateur

                        // Créer l'objet Usermodel
                        Usermodel user = Usermodel(
                          name: userName,
                          photo: userPhoto,
                          status: userStatus,
                          phoneNumber: userPhoneNumber,
                          city: userCity,
                          country: userCountry,
                          birthday: userBirthday,
                          id: userId,
                        );

                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              // Naviguer vers la page de profil de l'utilisateur
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profil(user: user),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMine ? Colors.blue[300] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(userPhoto),
                                    radius: 20,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    content,
                                    style: TextStyle(
                                      color: isMine ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
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
