import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/pages/welcome_page.dart';
import 'package:relax_app/widgets/player.dart';
import 'package:relax_app/widgets/profile.dart';
import 'package:relax_app/widgets/text_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index, required this.email}) : super(key: key);

  final int index;

  final String email;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;
  late User _user;

  void initImage(){
    DatabaseHelper.instance.findUser(widget.email).then((value) {
      setState(() {
        _user=value!;
      });
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    initImage();
    var pages = [
      const MusicPlayer(),
      const MusicPlayer(),
      ProfilePage(user: _user)
    ];
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Image.asset("assets/images/icon.png",width: 35,),
            leading: IconButton(icon: const Icon(Icons.menu), iconSize: 25,onPressed: () { openMenu(); },),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          actions: [CircleAvatar(backgroundImage: MemoryImage(_user.avatar), foregroundImage: MemoryImage(_user.avatar), radius: 25, )],
            ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/icon.png",width: 35),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Consts.contrastColor,
                  BlendMode.modulate,
                ),
                child: Image.asset("assets/images/icon.png",width: 35)),
              label: '.',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_note_list),
              label: '.',
            ),
            BottomNavigationBarItem(
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

  void openMenu() {
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
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //         const MainPage(title: "Labwork 1")),
                    //         (ret) => false);
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
                       onPressed: () {
                        _user.isAuthorized=0;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => WelcomePage()));
                         //   Navigator.pop(context);
                      //   final provider =
                      //   Provider.of<AuthHelper>(context, listen: false);
                      //   provider.signOut();
                       },
                      child: const Text('Sign out')))
            ],
          ),
        ),
      );
    }));
  }
}
