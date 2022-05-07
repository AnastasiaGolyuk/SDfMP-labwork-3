import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class ViewPhotoPage extends StatefulWidget {
  const ViewPhotoPage({Key? key, required this.bytes}) : super(key: key);
  
  final Uint8List bytes;

  @override
  _ViewPhotoPageState createState() => _ViewPhotoPageState();
}

class _ViewPhotoPageState extends State<ViewPhotoPage> {

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
        body: Container( width: Consts.getWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(widget.bytes),
              fit: BoxFit.fitWidth,
            ),
          ),
            ));
  }

}
