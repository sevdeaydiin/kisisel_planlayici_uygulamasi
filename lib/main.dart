import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/activities.dart';
import 'package:kisisel_planlayici_uygulamasi/menu.dart';
import 'package:kisisel_planlayici_uygulamasi/new_activities.dart';
import 'package:kisisel_planlayici_uygulamasi/profiles.dart';
import 'package:kisisel_planlayici_uygulamasi/sign_up.dart';
import 'package:kisisel_planlayici_uygulamasi/time_date_picker.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.pink.shade900, elevation: 3),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(200, 20),
            elevation: 4,
            primary: Colors.pink[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      home: Login(),
    );
  }
}
