import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/about_page.dart';
import 'package:relax_app/pages/count_bmi_page.dart';
import 'package:relax_app/pages/home_page.dart';
import 'package:relax_app/pages/slider_page.dart';
import 'package:relax_app/pages/welcome_page.dart';
import 'package:relax_app/pages/player_page.dart';
import 'package:relax_app/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index, required this.user})
      : super(key: key);

  final int index;

  final User user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Consts.pressedIndex = widget.index;
  }

  void _onItemTapped(int index) {
    setState(() {
      Consts.pressedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      HomePage(user: widget.user),
      MusicPlayer(
        text: Consts.text,
        musicPath: Consts.musicPath,
        imagePath: Consts.imagePath,
      ),
      ProfilePage(user: widget.user)
    ];
    return Scaffold(
        backgroundColor: Consts.darkColor,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/icon.png",
            width: 50,
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 25,
            onPressed: () {
              openMenu();
            },
          ),
          backgroundColor: Consts.darkColor,
          shadowColor: Colors.transparent,
          actions: [
            InkWell(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(widget.user.avatar),
                    foregroundImage: MemoryImage(widget.user.avatar),
                    radius: 20,
                  )),
              onTap: () {
                _onItemTapped(2);
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/icon.png", width: 35),
              activeIcon: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Consts.contrastColor,
                    BlendMode.modulate,
                  ),
                  child: Image.asset("assets/images/icon.png", width: 35)),
              label: '.',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note_list),
              label: '.',
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled),
              activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
              label: '.',
            ),
          ],
          iconSize: 25,
          backgroundColor: Consts.darkColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
          currentIndex: Consts.pressedIndex,
          selectedItemColor: Consts.contrastColor,
          onTap: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: pages[Consts.pressedIndex],
        ));
  }

  void openMenu() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Consts.darkColor,
        appBar: AppBar(
            backgroundColor: Consts.darkColor,
            shadowColor: Colors.transparent,
            title: const Text('Menu'),
            centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Consts.contrastColor,
                    fixedSize: const Size.fromWidth(200),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutPage()),
                        (ret) => true);
                  },
                  child: const Text('About developer')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Consts.contrastColor,
                    fixedSize: const Size.fromWidth(200),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IntroSliderPage()),
                              (ret) => true);
                  },
                  child: const Text('Hints')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Consts.contrastColor,
                    fixedSize: const Size.fromWidth(200),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountBMIPage()),
                              (ret) => true);
                  },
                  child: const Text('Calculate BMI')),
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Consts.contrastColor,
                        fixedSize: const Size.fromWidth(200),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        User usr = User(
                            id: widget.user.id,
                            username: widget.user.username,
                            email: widget.user.email,
                            passwordHash: widget.user.passwordHash,
                            bloodPressure: widget.user.bloodPressure,
                            weight: widget.user.weight,
                            dateBirth: widget.user.dateBirth,
                            avatar: widget.user.avatar,
                            isAuthorized: 0);
                        await DatabaseHelper.instance.updateUser(usr);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const WelcomePage()));
                      },
                      child: const Text('Sign out')))
            ],
          ),
        ),
      );
    }));
  }
}
