import 'dart:convert';

import 'dart:typed_data';

List<UploadedImage> imagesFromJson(String str) =>
    List<UploadedImage>.from(json.decode(str).map((x) => UploadedImage.fromJson(x)));

String imagesToJson(List<UploadedImage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UploadedImage {
  final int id;
  final int idUser;
  final Uint8List bytes;
  final String timeUpload;

  UploadedImage(
      {required this.id,
        required this.idUser,
        required this.bytes, required this.timeUpload});

  factory UploadedImage.fromJson(Map<String, dynamic> json) => UploadedImage(
    id: json["id"],
    idUser: json["idUser"],
    bytes: json["bytes"],
    timeUpload: json["timeUpload"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idUser": idUser,
    "bytes": bytes,
    "timeUpload": timeUpload
  };
}
