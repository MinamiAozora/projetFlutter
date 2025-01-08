import 'package:cloud_firestore/cloud_firestore.dart';

class Messagemodel {
  final String sender;
  final String content;
  final bool isMine;
  final Timestamp time;
  Messagemodel({required this.sender, required this.content, required this.isMine,required this.time});
}