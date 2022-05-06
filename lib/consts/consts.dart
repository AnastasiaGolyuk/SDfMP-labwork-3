import 'package:flutter/material.dart';

class Consts {
  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static const productsAPIUrlBrand =
      'http://makeup-api.herokuapp.com/api/v1/products.json?brand=';

  static const okStatus = 200;

  static const simpleFont = 'Barlow';
  static const titleFont = 'Cinzel';

  static const darkColor = Color(0xff0a1b23);
  static const contrastColor = Color(0xffb5bda2);

  static const trueDB = 1;
  static const falseDB = 0;
}
