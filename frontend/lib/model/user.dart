import 'dart:convert';

class User {
  String _id;
  String fullname;
  String username;
  String email;
  String address;
  String imageUrl;
  String city;
  String role;

  get id => _id;

  User(
      {String id,
      String fullname,
      String username,
      String imageUrl,
      String email,
      String address,
      String city,
      String role}) {
    this._id = id;
    this.fullname = fullname;
    this.username = username;
    this.email = email;
    this.address = address;
    this.city = city;
    this.imageUrl = imageUrl;
    this.role = role;
  }
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['_id'].toString(),
      fullname: parsedJson['fullname'].toString(),
      username: parsedJson['username'].toString(),
      imageUrl: parsedJson['imageUrl'].toString(),
      email: parsedJson['email'].toString(),
      address: parsedJson['address'].toString(),
      city: parsedJson['city'].toString(),
      role: parsedJson['role'].toString(),
    );
  }

  factory User.fromJsonString(String data) {
    final Map parsed = json.decode(data);
    return User.fromJson(parsed);
  }
}
