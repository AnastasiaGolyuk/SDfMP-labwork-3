import 'dart:convert';
import 'dart:io';
import "package:flutter/cupertino.dart";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/models/user.dart';
import 'package:relax_app/pages/main_page.dart';
import 'package:relax_app/widgets/text_field.dart';

class CountBMIPage extends StatefulWidget {
  CountBMIPage({Key? key}) : super(key: key);

  @override
  _CountBMIPageState createState() => _CountBMIPageState();
}

class _CountBMIPageState extends State<CountBMIPage> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();

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
        body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 10,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment.topLeft,
                                  image: AssetImage("assets/images/icon.png"))),
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Calculate BMI",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 10),
                      child: Column(
                        children: <Widget>[
                          CustomTextField(
                            inputType: TextInputType.number,
                            initialValue: "",
                            label: 'Weight (kg)*',
                            controller: weightController,
                            isPasswordField: false,
                          ),
                          CustomTextField(
                            inputType: TextInputType.number,
                            initialValue: "",
                            label: 'Height (m)*',
                            controller: heightController,
                            isPasswordField: false,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Consts.contrastColor,
                            fixedSize: Size(Consts.getWidth(context), 50)),
                        onPressed: () async {
                          if (validate()) {
                            setState(() {
                              res="BMI: ${calculateBMI(double.parse(weightController.text),
                                  double.parse(heightController.text)).toStringAsFixed(2)}";
                            });
                          }
                        },
                        child: Text(
                          "Calculate",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(alignment: Alignment.center, child:
                    Text(res, textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Consts.contrastColor),)
                    )],
                ),
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          opacity: 0.3,
                          image: AssetImage("assets/images/leaf1.png"),
                          fit: BoxFit.cover)),
                ),
              ],
            )));
  }

  String res="";

  double calculateBMI(double weight, double height) {
    return (weight / (height * height));
  }

  String checkFields() {
    if (weightController.text.isEmpty) {
      return "Input weight!";
    }
    if (heightController.text.isEmpty) {
      return "Input height!";
    }
    if (weightController.text.contains(",")||heightController.text.contains(",")) {
      return "Please, input double with \'.\'";
    }
    else {
      return "";
    }
  }

  void _showMessage(BuildContext context, String message,
      String content) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: TextStyle(
                fontSize: 18,),
            ),
            content: Text(
              content, style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  bool validate() {
    String error = checkFields();
    if (error != "") {
      _showMessage(context, "Validation error", error);
      return false;
    }
    return true;
  }
}
