import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/about_page.dart';
import 'package:relax_app/pages/home_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/pages/welcome_page.dart';
import 'package:relax_app/pages/player_page.dart';
import 'package:relax_app/pages/profile_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index, required this.user})
      : super(key: key);

  final int index;

  final User user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  // User widget.user = User(
  //     avatar: Uint8List(1),
  //     id: 765,
  //     username: "",
  //     email: "",
  //     passwordHash: "",
  //     isAuthorized: 1,
  //     dateBirth: '');
  //
  // void initUser() {
  //   DatabaseHelper.instance.findUser(widget.email).then((value) {
  //     setState(() {
  //       if (value != null) {
  //         widget.user = User(
  //             id: value.id,
  //             username: value.username,
  //             email: value.email,
  //             dateBirth: value.dateBirth,
  //             passwordHash: value.passwordHash,
  //             avatar: value.avatar,
  //             isAuthorized: value.isAuthorized);
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    //initUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      HomePage(user: widget.user),
      const MusicPlayer(),
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
            Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: CircleAvatar(
                  backgroundImage: MemoryImage(widget.user.avatar),
                  foregroundImage: MemoryImage(widget.user.avatar),
                  radius: 20,
                ))
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
          currentIndex: _selectedIndex,
          selectedItemColor: Consts.contrastColor,
          onTap: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: pages[_selectedIndex],
        ));
  }

  void openMenu() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        backgroundColor: Consts.darkColor,
        appBar: AppBar(
            backgroundColor: Consts.darkColor,
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
                            builder: (context) =>
                                const AboutPage()),
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
                    //   Navigator.pushAndRemoveUntil(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const IntroSliderPage()),
                    //           (ret) => true);
                  },
                  child: const Text('Hints')),
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
