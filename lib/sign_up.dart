import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController? _pcontroller = new TextEditingController();
TextEditingController? tc = new TextEditingController();
TextEditingController? ad = new TextEditingController();
TextEditingController? soyad = new TextEditingController();

class _SignUpState extends State<SignUp> with MyStyle {
  DateTime date = DateTime.now();
  final String appbarText = 'Sign Up';
  final _birthday = 'Select Birthday';
  int state = 0;
  bool software = false;
  bool hardware = false;
  bool ai = false;
  bool driver_licence = false;
  bool isSelect = true;
  final no = 'No';
  final yes = 'Yes';
  final softwareText = 'Software';
  final hardwareText = 'Hardware';
  final aiText = 'AI';
  final marriedText = 'Married';
  final singleText = 'Single';
  final dl = 'Driver Licence';
  final _signUp = 'Sign Up';
  void _change(isSelected) {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarText),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      body: ListView(children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NewTextField(
                  text: 'T.C. Number:',
                  maxLine: 11,
                  password: false,
                  inputType: TextInputType.number,
                  controller: tc,
                ),
                NewTextField(
                  text: 'First Name:',
                  password: false,
                  controller: ad,
                ),
                SizedBox(height: 10),
                NewTextField(
                  text: 'Last Name:',
                  password: false,
                  controller: soyad,
                ),
                TextField(
                  cursorColor: Colors.black,
                  controller: _pcontroller,
                  obscureText: isSelect,
                  decoration: InputDecoration(
                      hintText: 'Password:',
                      prefixText: ' ',
                      suffix: IconButton(
                        onPressed: () {
                          _change(isSelect);
                        },
                        icon: Icon(
                            isSelect ? Icons.visibility : Icons.visibility_off),
                      ),
                      hintStyle: TextStyle(color: Colors.pink[900]),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                ElevatedButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                      );
                      if (newDate == null) return;
                      setState(() => date = newDate);
                      print('dg: $newDate');
                    },
                    child: Text(_birthday)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: RadioListTile(
                      activeColor: Colors.pink[900],
                      value: 1,
                      groupValue: state,
                      onChanged: (secim) {
                        setState(() {
                          state = secim as int;
                          print(secim);
                        });
                      },
                      title: Text(marriedText),
                    )),
                    Expanded(
                        child: RadioListTile(
                      value: 2,
                      groupValue: state,
                      activeColor: Colors.pink[900],
                      onChanged: (secim) {
                        setState(() {
                          state = secim as int;
                          print(secim);
                        });
                      },
                      title: Text(singleText),
                    ))
                  ],
                ),
                CheckboxListTile(
                  value: software,
                  checkColor: Colors.white,
                  activeColor: Colors.pink[900],
                  onChanged: (stat) {
                    setState(() {
                      software = stat!;
                      print(software);
                    });
                  },
                  title: Text(softwareText),
                ),
                CheckboxListTile(
                  value: hardware,
                  checkColor: Colors.white,
                  activeColor: Colors.pink[900],
                  onChanged: (stat) {
                    setState(() {
                      hardware = stat!;
                      print(hardware);
                    });
                  },
                  title: Text(hardwareText),
                ),
                CheckboxListTile(
                  value: ai,
                  checkColor: Colors.white,
                  activeColor: Colors.pink[900],
                  onChanged: (stat) {
                    setState(() {
                      ai = stat!;
                      print(ai);
                    });
                  },
                  title: Text(aiText),
                ),
                SwitchListTile(
                  value: driver_licence,
                  onChanged: (secim) {
                    setState(() {
                      driver_licence = secim;
                    });
                  },
                  title: Text(dl),
                  subtitle: TextButton(
                      onPressed: () {
                        _change(driver_licence);
                      },
                      child: Text(
                        driver_licence ? yes : no,
                        style: TextStyle(color: Colors.black),
                      )),
                  activeColor: Colors.pink[900],
                  activeTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.platform,
                ),
                ElevatedButton(
                    onPressed: () async {
                      String? ilgi_alani;
                      String? medeni_durum;
                      String? licence;
                      if (software)
                        ilgi_alani = "software";
                      else if (hardware)
                        ilgi_alani = "hardware";
                      else if (ai) ilgi_alani = "ai";
                      if (state == 1) {
                        medeni_durum = "married";
                      } else
                        medeni_durum = "single";

                      if (driver_licence) {
                        licence = "yes";
                      } else {
                        licence = "no";
                      }

                      Database db;
                      Directory klasor =
                          await getApplicationDocumentsDirectory();
                      String veritabyolu = join(klasor.path, "kisi.sqlite");

                      if (await databaseExists(veritabyolu)) {
                        db = await openDatabase(veritabyolu, version: 1);
                      } else {
                        db = await openDatabase(veritabyolu,
                            version: 1, onCreate: dbOlustur);
                      }

                      var veriler = Map<String, dynamic>();
                      veriler["tc"] = tc?.text;
                      veriler["name"] = ad?.text;
                      veriler["lastname"] = soyad?.text;
                      veriler["password"] = _pcontroller?.text;
                      veriler["birthday"] = date.toString();
                      veriler["marital_status"] = medeni_durum;
                      veriler["interest"] = ilgi_alani;
                      veriler["driver_licence"] = licence;
                      await db.insert("kisiler", veriler);
                      print('veriler eklendi');

                      Navigator.pop(context);
                    },
                    child: Text(_signUp)),
                ElevatedButton(
                    onPressed: () async {
                      Database db;
                      Directory klasor =
                          await getApplicationDocumentsDirectory();
                      String veritabyolu = join(klasor.path, "kisi.sqlite");

                      if (await databaseExists(veritabyolu)) {
                        print("var");
                        db = await openDatabase(veritabyolu);
                        List<Map<String, dynamic>> maps =
                            await db.rawQuery("SELECT * FROM kisiler");
                        List.generate(maps.length, (index) {
                          var goster = maps[index];
                          print(goster["tc"]);
                          print(goster["name"]);
                          print(goster["lastname"]);
                          print(goster["password"]);
                          print(goster["birthday"]);
                          print(goster["marital_status"]);
                          print(goster["interest"]);
                          print(goster["driver_licence"]);
                        });
                      } else {
                        print("vt yok");
                      }

                      //Navigator.pop(context);
                    },
                    child: Text('Show')),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> dbOlustur(Database db, int version) async {
    await db.execute(
        "CREATE TABLE kisiler (tc INTEGER, name TEXT, lastname TEXT, password TEXT,birthday TEXT,marital_status TEXT, interest TEXT, driver_licence TEXT)");
  }
}

class NewTextField extends StatelessWidget {
  int? maxLine;
  String? text;
  bool password = false;
  List<TextInputFormatter>? input;
  TextInputType? inputType;
  TextEditingController? controller = new TextEditingController();

  NewTextField(
      {required this.text,
      this.maxLine,
      required this.password,
      this.inputType,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      maxLength: maxLine,
      obscureText: password,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: text ?? 'null',
          prefixText: ' ',
          hintStyle: TextStyle(color: Colors.pink[900]),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
    );
  }
}
