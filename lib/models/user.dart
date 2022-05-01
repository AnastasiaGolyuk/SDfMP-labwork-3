class User {
  final int id;
  final String username;
  final String email;
  final String passwordHash;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.passwordHash});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        passwordHash: json["passwordHash"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "passwordHash": passwordHash
      };
}
