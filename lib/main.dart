import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/pages/splashscreen_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Relax app',
          debugShowCheckedModeBanner: false,
          home: SplashscreenPage(),
        );
      }
}
