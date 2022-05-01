import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_app/pages/sign_in_page.dart';
import 'package:relax_app/pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Lab2',
          debugShowCheckedModeBanner: false,
          home: const WelcomePage(
          ),
        );
      }
}
