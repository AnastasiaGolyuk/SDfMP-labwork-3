import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/uploaded_image.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/edit_profile_page.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/pages/view_photo_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var images = <UploadedImage>[].obs;

  Future<List<UploadedImage>> getImages() async {
    var res = await DatabaseHelper.instance.getImages(widget.user.id);
    return res;
  }

  void initImages() {
    getImages().then((value) {
      setState(() {
        images = value.reversed.toList().obs;
        images.refresh();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initImages();
  }

  late File image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        addImageToDB(this.image);
        initImages();
        images.refresh();
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> addImageToDB(File image) async {
    Uint8List imgBytes = await image.readAsBytes();
    int id = await DatabaseHelper.instance.getImagesCount() + 1;
    UploadedImage img = UploadedImage(
        id: id,
        idUser: widget.user.id,
        bytes: imgBytes,
        timeUpload: DateTime.now().toString().substring(0, 16));
    await DatabaseHelper.instance.addImage(img);
  }

  Widget _showImages(List<UploadedImage> list) {
    final double tileHeight = 90;
    final double tileWidth = Consts.getWidth(context) / 2;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: (tileWidth / tileHeight),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15, //maxCrossAxisExtent: null
        ),
        itemCount: list.length,
        itemBuilder: (BuildContext ctx, index) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Consts.contrastColor,
              ),
              onPressed: () {
                index == list.length - 1
                    ? pickImage()
                    : {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewPhotoPage(
                                      bytes: list[index].bytes,
                                    )),
                            (ret) => true)
                      };
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(list[index].bytes),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  //Image.memory(list[index].bytes),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text(
                          index == list.length - 1
                              ? "+"
                              : list[index].timeUpload,
                          style: TextStyle(fontSize: 18)))
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Consts.darkColor,
        width: Consts.getWidth(context),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            children: [
              CircleAvatar(
                radius: Consts.getWidth(context) / 8,
                foregroundImage: MemoryImage(widget.user.avatar),
              ),
              Container(
                width: Consts.getWidth(context) / 1.85,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15),
                child: Column(children: [
                  Text(
                    "User name: ${widget.user.username}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Date of birth: ${widget.user.dateBirth.substring(0, 10)} (${DateTime.now().difference(DateTime.parse(widget.user.dateBirth)).inDays ~/ 365})",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.user.weight == 0
                        ? "Weight: -"
                        : "Weight: ${widget.user.weight}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.user.bloodPressure == 0
                        ? "Blood pressure: -"
                        : "Blood pressure: ${widget.user.bloodPressure}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Email: ${widget.user.email}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 3,
                    textAlign: TextAlign.left,
                  ),
                ]),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          EditProfilePage(user: widget.user)),
                          (ret) => true);
                },
                icon: Icon(CupertinoIcons.pencil),
                iconSize: 20,
                color: Colors.white,
              )
            ],
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: _showImages(images)),
          )
        ]));
  }
}
