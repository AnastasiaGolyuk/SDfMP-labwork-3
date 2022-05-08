import 'dart:io';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:relax_app/consts/consts.dart';
import 'package:relax_app/models/horoscope.dart';

import 'package:html/parser.dart';

class APIHoroscope extends GetxController {
  var isLoading = true.obs;
  var horoscopeList = <Horoscope>[].obs;

  @override
  Future<void> onInit() async {
    fetchHoroscope();
    super.onInit();
  }


  void fetchHoroscope() async {
    try {
          var response = await http.get(Uri.parse(
              Consts.horoscopeAPIUrl));
          if (response.statusCode == Consts.okStatus) {
            var doc = parse(response.body);
            var elements = doc.getElementsByClassName("horoscope__description");
            for (int i=0;i<2;i++){
              elements.removeAt(0);
            }
            for(int i=0;i<elements.length;i++){
              var description = elements[i].text.trimLeft();
              var horoscope = Horoscope(sign: Consts.zodiacSigns.elementAt(i), description: description);
              horoscopeList.add(horoscope);
            }
            // final horoscopeParsed = horoscopeFromJson(response.body);
            // horoscopeList.add(horoscopeParsed.first);
          }
    } catch (e, stackTrace) {
      if (e is SocketException) {

      }
    } finally {
      print(horoscopeList.length);
      isLoading(false);
    }
  }
}
