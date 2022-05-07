import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/db/db_helper.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/pages/sign_up_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.user}) : super(key: key);

  User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,

    );
  }
}
