import 'dart:typed_data';

class User {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  int isAuthorized;
  final Uint8List avatar;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.passwordHash,
      required this.isAuthorized,
      required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      passwordHash: json["passwordHash"],
      isAuthorized: json["isAuthorized"],
      avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "passwordHash": passwordHash,
        "isAuthorized": isAuthorized,
        "avatar": avatar
      };
}
