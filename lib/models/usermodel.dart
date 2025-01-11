class Usermodel {
  String name;
  String photo;
  String status;
  String phoneNumber;
  String city;
  String country;
  String birthday;
  String id;

  Usermodel({
    this.name="",
    this.photo="",
    required this.status,
    this.phoneNumber="",
    this.city="",
    this.country="",
    this.birthday="",
    required this.id,
  });
}