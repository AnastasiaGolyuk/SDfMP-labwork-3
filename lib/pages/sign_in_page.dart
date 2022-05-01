import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                      "Sign in",
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
                      CustomTextField(label: 'Email', controller: emailController,),
                      CustomTextField(label: 'Password', controller: passwordController,)
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
                      bool res = await _checkPasswordHash();
                      if (res) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage(index: 0, username: emailController.text,)));
                      }},
                    child: Text(
                      "Sign in",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Consts.contrastColor,
                        fixedSize: Size(Consts.getWidth(context), 50)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text(
                      "Profile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future<bool> _checkPasswordHash() async{
    User? user = await DatabaseHelper.instance.findUser(emailController.text);
    if (user!=null){
      return user.passwordHash==sha512.convert(utf8.encode(passwordController.text)).toString();
    }
    return false;
  }

}
