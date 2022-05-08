import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/welcome_page.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashscreenPage extends StatefulWidget {
  const SplashscreenPage({Key? key}) : super(key: key);

  @override
  _SplashscreenPageState createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {

  Widget widgetNavigate = const WelcomePage();
  

  Future<Widget> loadPage() async {

    User? user = await DatabaseHelper.instance.findAuthUser();
    if (user==null){
      return const WelcomePage();
    } else{
      return MainPage(index: 0, user: user);
    }
  }

  void initWidget(){
    loadPage().then((value) {
      setState(() {
        widgetNavigate=value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    initWidget();
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: widgetNavigate,
      imageBackground: const AssetImage("assets/images/bg2.jpg"),
      image: const Image(
        image: AssetImage("assets/images/icon.png"),
      ),
      photoSize: Consts.getWidth(context)/3,
      loaderColor: Colors.transparent,
    );
  }
}
