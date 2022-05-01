import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index, required this.username}) : super(key: key);

  final int index;

  final String username;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedIndex = 0;

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
    var pages = [

    ];

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Image.asset("assets/images/icon.png",width: 20,),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/icon.png",width: 20),
              activeIcon: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Consts.contrastColor,
                  BlendMode.modulate,
                ),
                child: Image.asset("assets/images/icon.png",width: 20)),
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
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: Consts.contrastColor,
          onTap: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(widget.username),
        ));
  }
}
