import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/sign_up.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'menu.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController tc = new TextEditingController();
TextEditingController password = new TextEditingController();

class _LoginState extends State<Login> with MyStyle {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final String signIn = 'Sign in';
    final signUp = 'Sign Up';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: size.height * .6,
            width: size.width * 0.85,
            decoration: MyBoxDecoration(20, Colors.white70),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      controller: tc,
                      myIcon: Icons.account_circle_rounded,
                      text: 'Username:',
                      durum: false,
                    ),
                    SizedBox(height: size.height * 0.02),
                    MyTextField(
                      controller: password,
                      myIcon: Icons.vpn_key,
                      text: 'Password:',
                      durum: true,
                    ),
                    SizedBox(height: size.height * 0.08),
                    InkWell(
                      onTap: () async {
                        var satir;
                        Database db;
                        Directory klasor =
                            await getApplicationDocumentsDirectory();
                        String veritabyolu = join(klasor.path, "kisi.sqlite");

                        if (await databaseExists(veritabyolu)) {
                          db = await openDatabase(veritabyolu);
                          List<Map<String, dynamic>> maps =
                              await db.rawQuery("SELECT * FROM kisiler");
                          List.generate(maps.length, (index) {
                            satir = maps[index];
                          });

                          if (satir["tc"].toString() == tc.text.toString() &&
                              satir["password"].toString() ==
                                  password.text.toString()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Menu(name: satir["name"])));
                          } else {
                            print('kullanıcı adı parola hatalı');
                          }
                        } else {
                          print("vt yok");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: MyBoxDecoration(20, Colors.pink.shade900),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Text(signIn,
                                style: myStyle.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyContainer(),
                          Text(signUp, style: myStyle),
                          MyContainer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration MyBoxDecoration(double value, Color colors) {
    return BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.all(Radius.circular(value)),
        boxShadow: [
          BoxShadow(color: Colors.black38),
        ]);
  }
}

class MyContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 75,
      color: Colors.white,
    );
  }
}

class MyTextField extends StatelessWidget {
  IconData? myIcon;
  String? text;
  bool durum;
  TextEditingController controller = new TextEditingController();
  MyTextField(
      {required this.myIcon,
      this.text,
      required this.controller,
      required this.durum});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: durum,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
          prefixIcon: Icon(
            myIcon,
            color: Colors.black54,
          ),
          hintText: text,
          prefixText: ' ',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3))),
    );
  }
}

class MyStyle {
  TextStyle myStyle = TextStyle(
    color: Colors.pink[900],
    fontSize: 19,
    fontWeight: FontWeight.w400,
  );
}
