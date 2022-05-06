import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/welcome_page.dart';
import 'package:splashscreen/splashscreen.dart';


class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  Future<Widget> loadPage() async {

    User? user = await DatabaseHelper.instance.findAuthUser();
    if (user==null){
      return WelcomePage();
    } else{
      return MainPage(index: 0, email: user.email);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: loadPage(),
      imageBackground: const AssetImage("assets/images/bg2.jpg"),
      image: const Image(
        image: AssetImage("assets/images/icon.png"),
      ),
      photoSize: Consts.getWidth(context)/3,
      loaderColor: Colors.transparent,
    );
  }
}
