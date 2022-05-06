import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
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
        body: Stack(
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
                      left: 30, right: 30, top: 100, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        label: 'Username',
                        controller: usernameController,
                        isPasswordField:false,
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
                    onPressed: () {
                      if (_checkPasswords()) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MainPage(
                                      index: 0,
                                      email: emailController.text,
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
        ));
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

  bool _checkPasswords() {
    var hashFirst =
        sha512.convert(utf8.encode(passwordController.text)).toString();
    var hashSecond = sha512
        .convert(utf8.encode(confirmedPasswordController.text))
        .toString();
    if (hashFirst == hashSecond) {
      _save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _save() async {
    Uint8List avatarBytes = Uint8List(1);
    rootBundle.load("assets/image/profile_pic.jpg").then((value) {
      avatarBytes=value.buffer.asUint8List();
    });
    await DatabaseHelper.instance.addUser(User(
        id: await DatabaseHelper.instance.getUsersCount() + 1,
        email: emailController.text,
        username: usernameController.text,
        passwordHash: sha512
            .convert(utf8.encode(confirmedPasswordController.text))
            .toString(),
        isAuthorized: Consts.trueDB,
    avatar: avatarBytes));
  }
}
