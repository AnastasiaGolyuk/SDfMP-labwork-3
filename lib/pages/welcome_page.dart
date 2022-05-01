import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/pages/sign_in_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg2.jpg"), fit: BoxFit.cover)),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 150),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/icon.png"))),
              )),
          Column(
            children: [
              Text(
                "HELLO",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 80),
              child:
              Text(
                "Enjoy the compilings.\n Be focused.\n Do well",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Consts.contrastColor,
                      fixedSize: Size(Consts.getWidth(context), 45)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  )),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text(" Sign up", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    ),)
                  )
                ],
              ),
            ],
          )
        ],
      ),
    ]));
  }
}
