class Mood {
  final int id;
  final int idUser;
  final String mood;
  final String timeUpload;

  Mood(
      {required this.id,
        required this.idUser,
        required this.mood, required this.timeUpload});

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
      id: json["id"],
      idUser: json["idUser"],
      mood: json["mood"],
      timeUpload: json["timeUpload"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idUser": idUser,
    "mood": mood,
    "timeUpload": timeUpload
  };
}
