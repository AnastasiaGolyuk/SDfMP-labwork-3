import 'dart:typed_data';

class User {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String dateBirth;
  final int weight;
  final int bloodPressure;
  final int isAuthorized;
  final Uint8List avatar;

  User({required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.dateBirth,
    required this.weight,
    required this.bloodPressure,
    required this.isAuthorized,
    required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
          id: json["id"],
          username: json["username"],
          email: json["email"],
          passwordHash: json["passwordHash"],
          dateBirth: json["dateBirth"],
          weight: json["weight"],
          bloodPressure: json["bloodPressure"],
          isAuthorized: json["isAuthorized"],
          avatar: json["avatar"]);

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "username": username,
        "email": email,
        "passwordHash": passwordHash,
        "dateBirth": dateBirth,
        "weight": weight,
        "bloodPressure": bloodPressure,
        "isAuthorized": isAuthorized,
        "avatar": avatar
      };
}
