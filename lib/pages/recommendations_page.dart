import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_app/api/api_helper.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/mood.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({Key? key, required this.moods, required this.user}) : super(key: key);

  final List<Mood> moods;

  final User user;

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  String timeOfTheDay() {
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'morning';
    }
    if (hour >= 12 && hour < 23) {
      return 'day';
    }
    return 'night';
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
        body: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 100,
                  child: Image.asset("assets/images/" +
                      widget.moods[1].mood.toLowerCase() +
                      ".png"),
                ),
                title: Text("Your common mood is \"${widget.moods[1].mood}\""),
                subtitle: InkWell(
                  child: Text(
                    "Listen music recommendation.",
                    style: TextStyle(color: Consts.contrastColor, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onTap: () {
                    setPathsAndText(widget.moods[1], null);
                    setState(() {
                      Consts.pressedIndex=1;
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => MainPage(
                          index: Consts.pressedIndex,
                          user: widget.user,
                        )));
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Container(
                  width: 110,
                  height: 150,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/" + timeOfTheDay() + ".png",
                        height: 50,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                          "assets/images/" +
                              widget.moods[0].mood.toLowerCase() +
                              ".png",
                          height: 50,
                          fit: BoxFit.fitWidth)
                    ],
                  ),
                ),
                title: Text(
                    "It's ${timeOfTheDay()}. Your recent mood is \"${widget.moods[0].mood}\""),
                subtitle: InkWell(
                  child: Text(
                    "Listen music recommendation.",
                    style: TextStyle(color: Consts.contrastColor, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onTap: () {
                    setPathsAndText(widget.moods[0], timeOfTheDay());
                    setState(() {
                      Consts.pressedIndex=1;
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => MainPage(
                          index: Consts.pressedIndex,
                          user: widget.user,
                        )));
                  },
                ),
              ),
            )
          ],
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        ));
  }

  void setPathsAndText(Mood mood, String? time) {
    if (time != null) {
      if (mood.mood == "Calm" || mood.mood == "Relax" || mood.mood == "Happy") {
        Consts.musicPath = "assets/music/" + time.toLowerCase() + ".mp3";
        if (time != 'Night') {
          Consts.imagePath = Consts.pathsRec.elementAt(1);
          Consts.text = 'Be productive!';
        } else {
          Consts.imagePath = Consts.pathsRec.elementAt(2);
          Consts.text = 'Time to chill and sleep';
        }
      } else {
        if (mood.mood=='Anxious'){
          Consts.musicPath = "assets/music/sad.mp3";
        } else {
          Consts.musicPath = "assets/music/" + mood.mood.toLowerCase() + ".mp3";
        }
        Consts.imagePath = Consts.pathsRec.elementAt(4);
        Consts.text = 'Make yourself comfy and try to relax!';
      }
    } else {
      if (mood.mood=='Anxious'){
        Consts.musicPath = "assets/music/sad.mp3";
      } else {
        Consts.musicPath = "assets/music/" + mood.mood.toLowerCase() + ".mp3";
      }
      if (mood.mood == "Calm" || mood.mood == "Relax" || mood.mood == "Happy") {
        Consts.imagePath = Consts.pathsRec.elementAt(0);
        Consts.text = 'Make memories with your friend!';
      } else {
        Consts.imagePath = Consts.pathsRec.elementAt(3);
        Consts.text = 'Read or do something to relax.';
      }
    }
  }
}
