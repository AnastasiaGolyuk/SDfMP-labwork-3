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
import 'package:relax_app/pages/horoscopes_page.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/recommendations_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Mood> moods = <Mood>[];

  bool isRecButtonDisabled = true;

  final APIHoroscope _apiHoroscope = Get.put(APIHoroscope());

  Future<Set<Mood>?> getMoods() async {
    var moodRecent =
        await DatabaseHelper.instance.getRecentMood(widget.user.id);
    var moodCommon =
        await DatabaseHelper.instance.getCommonMood(widget.user.id);
    if (moodCommon != null && moodRecent != null) {
      var moodsDB = {moodRecent, moodCommon};
      return moodsDB;
    } else {
      return null;
    }
  }

  void initMoods() {
    getMoods().then((value) {
      if (value != null) {
        setState(() {
          moods = value.toList();
          isRecButtonDisabled = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initMoods();
  }

  Future<void> saveMood(String moodTitle) async {
    int id = await DatabaseHelper.instance.getMoodsCount() + 1;
    int idUser = widget.user.id;
    Mood mood = Mood(
        id: id,
        idUser: idUser,
        mood: moodTitle,
        timeUpload: DateTime.now().toString());
    await DatabaseHelper.instance.addMood(mood);
    initMoods();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome back, ${widget.user.username}!",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "How are you feeling today?",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(padding: EdgeInsets.symmetric(horizontal: 8),child:
                    Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          child: Image.asset(
                            Consts.paths.elementAt(index),
                            width: 70,
                          ),
                          onTap: () async {
                            await saveMood(Consts.titles.elementAt(index));
                          },
                        ),
                      ),
                      Text(
                        Consts.titles.elementAt(index),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ));
                },
                itemCount: 5,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            Stack(
              children: [
                Container(
                  width: Consts.getWidth(context) - 25,
                  height: 150,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  child: Image.asset("assets/images/girl.png"),
                  left: 200,
                  top: 15,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Mood recommendations",
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  width: 230,
                    padding: EdgeInsets.only(top: 40, left: 15),
                    child: Text(
                      "Music based on your common and recent mood",
                      style: TextStyle(fontSize: 15),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 90, left: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        isRecButtonDisabled
                            ? null
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RecommendationsPage(moods: moods, user: widget.user,)),
                                (ret) => true);
                      },
                      child: Text("View"),
                      style: ElevatedButton.styleFrom(
                          primary: isRecButtonDisabled?Colors.black26:Consts.contrastColor,
                          fixedSize: Size(150, 35)),
                    ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Stack(
              children: [
                Container(
                  width: Consts.getWidth(context) - 25,
                  height: 150,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  child: Image.asset("assets/images/heart.png"),
                  left: 220,
                  top: 15,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Horoscope for today",
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                    width: 240,
                    padding: EdgeInsets.only(top: 40, left: 15),
                    child: Text(
                      "Read your and other zodiac horoscopes for today!",
                      style: TextStyle(fontSize: 15),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 90, left: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HoroscopesPage(horoscope: _apiHoroscope.horoscopeList,)),
                            (ret) => true);
                      },
                      child: Text("Read"),
                      style: ElevatedButton.styleFrom(
                          primary: Consts.contrastColor,
                          fixedSize: Size(150, 35)),
                    ))
              ],
            )
          ],
        ));
  }
}
