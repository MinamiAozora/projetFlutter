import 'messagemodel.dart';
import 'postmodel.dart';

class Usermodel {
  String name;
  String photo;
  String status;
  int notifications;
  String phoneNumber;
  String city;
  String country;
  String birthday;
  List<Messagemodel> messages;
  List<Postmodel> posts;

  Usermodel({
    required this.name,
    required this.photo,
    required this.status,
    required this.notifications,
    required this.phoneNumber,
    required this.city,
    required this.country,
    required this.birthday,
    required this.messages,
    required this.posts,
  });
}