import 'dart:convert';
import 'dart:typed_data';

import "package:flutter/cupertino.dart";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/uploaded_image.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_in_page.dart';
import 'package:relax_app/widgets/text_field.dart';
import 'package:crypto/crypto.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  DateTime date=DateTime.now();

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
          child:
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      opacity: 0.3,
                      image: AssetImage("assets/images/leaf1.png"),
                      fit: BoxFit.cover)),
            ),
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
                      "Register",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30, right: 30, top: 60, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        label: 'Username',
                        controller: usernameController,
                        isPasswordField:false,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child:
                      Text("Date of birth", style: TextStyle(fontSize: 15,
                          color: Colors.white))),
                      Container(
                        height:80,
                        child: CupertinoDatePicker(
                          backgroundColor: Colors.white,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime value) {
                            setState(() {
                              date=DateUtils.dateOnly(value);
                            });
                          },
                        )
                      ),
                      CustomTextField(
                        label: 'Email',
                        controller: emailController,
                        isPasswordField: false,
                      ),
                      CustomTextField(
                        label: 'Password',
                        controller: passwordController,
                        isPasswordField: true,
                      ),
                      CustomTextField(
                        label: 'Confirm password',
                        controller: confirmedPasswordController,
                        isPasswordField: true,
                      )
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
                      User? user = await _checkPasswords();
                      if (user!=null) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 0,
                                      user: user,
                                    )));
                      } else {
                        _showMessage(context, "Passwords are not the same", "Please, check your input and try again.");
                      }
                    },
                    child: Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        },
                        child: Text(
                          " Sign in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ))
                  ],
                )
              ],
            )
          ],
        )));
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

  Future<User?> _checkPasswords() async {
    var hashFirst =
        sha512.convert(utf8.encode(passwordController.text)).toString();
    var hashSecond = sha512
        .convert(utf8.encode(confirmedPasswordController.text))
        .toString();
    if (hashFirst == hashSecond) {
      User user = await _save();
      return user;
    } else {
      return null;
    }
  }

  Future<User> _save() async {
    Uint8List avatarBytes = Uint8List(1);
    Uint8List imgBytes = Uint8List(1);
    rootBundle.load("assets/images/profile_pic.jpg").then((value) {
      avatarBytes=value.buffer.asUint8List();
    });
    rootBundle.load("assets/images/default_img.jpg").then((value) {
      imgBytes=value.buffer.asUint8List();
    });
    int id = await DatabaseHelper.instance.getUsersCount() + 1;
    User user = User(
        id: id,
        email: emailController.text,
        username: usernameController.text,
        dateBirth: date.toString(),
        passwordHash: sha512
            .convert(utf8.encode(confirmedPasswordController.text))
            .toString(),
        isAuthorized: Consts.trueDB,
        avatar: avatarBytes);
    await DatabaseHelper.instance.addUser(user);
    int imgID = await DatabaseHelper.instance.getImagesCount();
    UploadedImage img = UploadedImage(id: imgID, bytes: imgBytes, idUser: id,timeUpload: DateTime.now().toString().substring(11));
    await DatabaseHelper.instance.addImage(img);
    return user;
  }
}
