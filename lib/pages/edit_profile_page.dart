import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import "package:flutter/cupertino.dart";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/uploaded_image.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/widgets/text_field.dart';
import 'package:crypto/crypto.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final usernameController = TextEditingController();
  final weightController = TextEditingController();
  final bloodPressureController = TextEditingController();
  DateTime date = DateTime.now();

  var image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Consts.darkColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Consts.darkColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              alignment: Alignment.topLeft,
                              image: AssetImage("assets/images/icon.png"))),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Edit profile",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Text("Change photo",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await pickImage();
                        },
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        initialValue: widget.user.username,
                        label: 'Username*',
                        controller: usernameController,
                        isPasswordField: false,
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Text("Date of birth*",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                      Container(
                          height: 80,
                          child: CupertinoDatePicker(
                            backgroundColor: Colors.white,
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.parse(widget.user.dateBirth),
                            onDateTimeChanged: (DateTime value) {
                              setState(() {
                                date = DateUtils.dateOnly(value);
                              });
                            },
                          )),
                      CustomTextField(
                        inputType: TextInputType.number,
                        initialValue: widget.user.weight==0?"":widget.user.weight.toString(),
                        label: 'Weight (kg)',
                        controller: weightController,
                        isPasswordField: false,
                      ),
                      CustomTextField(
                        inputType: TextInputType.number,
                        initialValue: widget.user.bloodPressure==0?"":widget.user.bloodPressure.toString(),
                        label: 'Blood pressure (mmHg)',
                        controller: bloodPressureController,
                        isPasswordField: false,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Consts.contrastColor,
                        fixedSize: Size(Consts.getWidth(context), 50)),
                    onPressed: () async {
                      if (validate()) {
                        await _save();
                        Consts.pressedIndex = 2;
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) =>
                                MainPage(
                                  index: Consts.pressedIndex,
                                  user: widget.user,
                                )));
                      }},
                    child: Text(
                      "Edit",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.3,
                      image: AssetImage("assets/images/leaf1.png"),
                      fit: BoxFit.cover)),
            ),
          ],
        )));
  }

  String checkFields(){
    if (usernameController.text.isEmpty){
      return "Username shouldn't be empty!";
    }
    if (DateTime.now().difference(date).inDays<=0){
      return "Date must be earlier than today!";
    }
    if (weightController.text.contains(",")||bloodPressureController.text.contains(",")) {
      return "Please, input double with \'.\'";
    }
    else {
      return "";
    }
  }

  void _showMessage(BuildContext context, String message, String content) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: TextStyle(
                fontSize: 18,),
            ),
            content: Text(
              content, style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  bool validate(){
    String error = checkFields();
    if (error!=""){
      _showMessage(context, "Validation error", error);
      return false;
    }
    return true;
  }


  Future<void> _save() async {
    Uint8List avatar = widget.user.avatar;
    if (image!=null){
      avatar=await image.readAsBytes();
    }
    widget.user = User(
        id: widget.user.id,
        email: widget.user.email,
        username: usernameController.text,
        dateBirth: date.toString().substring(0, 10),
        passwordHash: widget.user.passwordHash,
        bloodPressure: double.parse(bloodPressureController.text).round(),
        weight: double.parse(weightController.text).round(),
        isAuthorized: Consts.trueDB,
        avatar: avatar);

    await DatabaseHelper.instance.updateUser(widget.user);
  }
}
