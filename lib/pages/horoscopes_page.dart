import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:relax_app/api/api_helper.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/horoscope.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class HoroscopesPage extends StatefulWidget {
  const HoroscopesPage({Key? key, required this.horoscope}) : super(key: key);

  final List<Horoscope> horoscope;

  @override
  _HoroscopesPageState createState() => _HoroscopesPageState();
}

class _HoroscopesPageState extends State<HoroscopesPage> {




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
        body: ListView.builder(
            itemBuilder: (BuildContext, index){
              return Card(
                child: ListTile(
                  leading: Container(width: 50,height: 50,child: Image.asset("assets/images/"+Consts.zodiacSigns.elementAt(index)+".png"),),
                  title: Text(widget.horoscope[index].sign),
                  subtitle: Text(widget.horoscope[index].description),
                ),
              );
            },
          itemCount: 12,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,

        ));
  }

}
