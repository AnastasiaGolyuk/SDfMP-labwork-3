import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.darkColor,
        appBar: AppBar(
            backgroundColor: Consts.darkColor,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            leading: IconButton(
                icon: const Icon(CupertinoIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: Consts.getWidth(context),
              child: Text(
                "Labwork 3",
                style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: Consts.titleFont),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: const Image(
                image: AssetImage('assets/images/my_photo.jpg'),
                width: 250,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
                "Anastasia Golyuk",
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: Consts.getWidth(context),
              child: Text(
                "951006",
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}
