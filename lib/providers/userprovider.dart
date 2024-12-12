import 'package:flutter/material.dart';

import '../models/messagemodel.dart';
import '../models/postmodel.dart';
import '../models/usermodel.dart';

class UserProvider with ChangeNotifier {
  // ignore: prefer_final_fields
    Usermodel _currentUser=Usermodel(
    name: 'Hank',
    photo: 'https://via.placeholder.com/150',
    status: 'busy',
    notifications: 0,
    phoneNumber: '01 77 66 55 44',
    city: 'Strasbourg',
    country: 'France',
    birthday: '25/12/1987',
    messages: [
      Messagemodel(sender: 'Me', content: 'remember to buy some vegetable', isMine: true),
      Messagemodel(sender: 'me', content: 'there\'s a birthday this sunday ', isMine: true),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Busy day, but making good progress!',
        like: 12,
        partage: 2,
        commentaires: ['Keep it up!', 'Great work!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Relaxing with some good music after a hectic day.',
        like: 8,
        partage: 1,
        commentaires: ['Sounds nice!', 'What are you listening to?'],
      ),
    ],
  );
  final List<Usermodel> _users = [
  Usermodel(
    name: 'Alice',
    photo: 'https://via.placeholder.com/150',
    status: 'online',
    notifications: 2,
    phoneNumber: '01 23 45 67 89',
    city: 'Paris',
    country: 'France',
    birthday: '12/05/1995',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hey Alice! How are you?', isMine: true),
      Messagemodel(sender: 'Alice', content: 'I\'m good! You?', isMine: false),
      Messagemodel(sender: 'Me', content: 'Doing well, thanks!', isMine: true),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Had an amazing day in Paris with friends!',
        like: 15,
        partage: 3,
        commentaires: ['Looks fun!', 'Wish I was there!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Just got back from a great trip to the mountains!',
        like: 20,
        partage: 5,
        commentaires: ['Stunning views!', 'Tell me more about it!'],
      ),
    ],
  ),
  Usermodel(
    name: 'Bob',
    photo: 'https://via.placeholder.com/150',
    status: 'busy',
    notifications: 3,
    phoneNumber: '01 98 76 54 32',
    city: 'Lyon',
    country: 'France',
    birthday: '23/08/1992',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hi Bob, are you free now?', isMine: true),
      Messagemodel(sender: 'Bob', content: 'I\'m in a meeting right now, talk later.', isMine: false),
      Messagemodel(sender: 'Me', content: 'Got it, talk soon!', isMine: true),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Just finished an intense workout session!',
        like: 12,
        partage: 2,
        commentaires: ['Great job!', 'Keep it up!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Enjoying a nice cup of coffee this morning!',
        like: 8,
        partage: 1,
        commentaires: ['Sounds relaxing!', 'What kind of coffee?'],
      ),
    ],
  ),
  Usermodel(
    name: 'Charlie',
    photo: 'https://via.placeholder.com/150',
    status: 'offline',
    notifications: 1,
    phoneNumber: '02 11 22 33 44',
    city: 'Marseille',
    country: 'France',
    birthday: '17/11/1990',
    messages: [
      Messagemodel(sender: 'Me', content: 'Good night, Charlie!', isMine: true),
      Messagemodel(sender: 'Charlie', content: 'Good night!', isMine: false),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Great day at the beach with friends!',
        like: 30,
        partage: 7,
        commentaires: ['Looks amazing!', 'I want to go there next time!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Enjoying a quiet night with a good book.',
        like: 10,
        partage: 2,
        commentaires: ['Nice choice!', 'What book are you reading?'],
      ),
    ],
  ),
  Usermodel(
    name: 'Diana',
    photo: 'https://via.placeholder.com/150',
    status: 'online',
    notifications: 0,
    phoneNumber: '01 55 44 33 22',
    city: 'Nice',
    country: 'France',
    birthday: '05/02/1993',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hey Diana, what\'s up?', isMine: true),
      Messagemodel(sender: 'Diana', content: 'Not much, just thinking of going for a walk.', isMine: false),
      Messagemodel(sender: 'Me', content: 'Sounds great, let\'s join!', isMine: true),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Enjoying the sunny weather in Nice today!',
        like: 25,
        partage: 4,
        commentaires: ['I love the sun!', 'What a beautiful place!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Just finished a hike in the mountains, amazing views!',
        like: 18,
        partage: 3,
        commentaires: ['Wow, looks beautiful!', 'You\'re so adventurous!'],
      ),
    ],
  ),
  Usermodel(
    name: 'Eve',
    photo: 'https://via.placeholder.com/150',
    status: 'busy',
    notifications: 0,
    phoneNumber: '02 66 77 88 99',
    city: 'Bordeaux',
    country: 'France',
    birthday: '30/06/1991',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hey Eve, can we talk later?', isMine: true),
      Messagemodel(sender: 'Eve', content: 'I\'m busy right now, let\'s chat after the meeting.', isMine: false),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Busy day at work, but feeling productive!',
        like: 14,
        partage: 3,
        commentaires: ['Keep it up!', 'You got this!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Loving this new coffee blend I tried!',
        like: 10,
        partage: 2,
        commentaires: ['What flavor is it?', 'Sounds delicious!'],
      ),
    ],
  ),
  Usermodel(
    name: 'Frank',
    photo: 'https://via.placeholder.com/150',
    status: 'offline',
    notifications: 0,
    phoneNumber: '03 44 55 66 77',
    city: 'Lille',
    country: 'France',
    birthday: '14/03/1988',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hey Frank, how are you?', isMine: true),
      Messagemodel(sender: 'Frank', content: 'I\'m offline now, let\'s talk later.', isMine: false),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'It\'s been a long week, but I\'m happy it\'s over!',
        like: 8,
        partage: 1,
        commentaires: ['You deserve some rest!', 'Enjoy your weekend!'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Spent the day with family, great times!',
        like: 15,
        partage: 3,
        commentaires: ['Family time is the best!', 'Glad you had fun!'],
      ),
    ],
  ),
  Usermodel(
    name: 'Grace',
    photo: 'https://via.placeholder.com/150',
    status: 'online',
    notifications: 0,
    phoneNumber: '01 88 99 00 11',
    city: 'Toulouse',
    country: 'France',
    birthday: '21/09/1994',
    messages: [
      Messagemodel(sender: 'Me', content: 'Hi Grace, I\'m ready to talk!', isMine: true),
      Messagemodel(sender: 'Grace', content: 'Great, let\'s start!', isMine: false),
    ],
    posts: [
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Just got back from a road trip with friends!',
        like: 22,
        partage: 5,
        commentaires: ['That looks so fun!', 'What was the best part?'],
      ),
      Postmodel(
        image: 'https://via.placeholder.com/100',
        text: 'Starting a new project today, feeling excited!',
        like: 18,
        partage: 4,
        commentaires: ['You\'re going to do great!', 'Good luck!'],
      ),
    ],
  ),
];


// Utilisateur actuel


  // Getter pour la liste des utilisateurs
  List<Usermodel> get users => _users;

  // Getter et Setter pour l'utilisateur actuel
  Usermodel get currentUser => _currentUser;

  set currentUser(Usermodel user) {
    _currentUser = user;
    notifyListeners();  // Notifie les widgets écoutant ce changement
  }

  // Ajouter un utilisateur
  void addUser(Usermodel user) {
    _users.add(user);
    notifyListeners();
  }

  // Liker un post
  void likePost(Usermodel user, Postmodel post) {
    post.like++;
    notifyListeners();
  }

  // Partager un post
  void sharePost(Usermodel user, Postmodel post) {
    post.partage++;
    user.posts.add(post);
    notifyListeners();
  }

  // Ajouter un commentaire
  void addComment(Usermodel user, Postmodel post, String comment) {
    post.commentaires.add(comment);
    notifyListeners();
  }
  void addPost(Usermodel user, Postmodel post) {
    user.posts.add(post);
    notifyListeners();
  }
}
