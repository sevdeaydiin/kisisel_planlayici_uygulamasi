import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/activities.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NewActivities extends StatefulWidget {
  var eklenen_etkinlik;
  NewActivities({this.eklenen_etkinlik});

  @override
  State<NewActivities> createState() => _NewActivitiesState();
}

class _NewActivitiesState extends State<NewActivities> {
  TextEditingController activ = new TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Activitie')),
      body: Padding(
        padding: EdgeInsets.only(top: 60, bottom: 60, left: 20, right: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: activ,
                  cursorColor: Colors.black38,
                  decoration: InputDecoration(
                      hintText: 'Title: ',
                      prefixText: ' ',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3))),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2050),
                        );
                        if (newDate == null) return;
                        setState(() => date = newDate);
                      },
                      icon: Icon(Icons.calendar_month)),
                  IconButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: time,
                      ).then((value) {
                        // print(value);
                        // print(value!.format(context));
                        // print("${value!.hour}:${value.minute}");
                      });
                    },
                    icon: Icon(Icons.watch_later),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      Database db2;
                      Directory klasor2 =
                          await getApplicationDocumentsDirectory();
                      String vtyolu = join(klasor2.path, "etkinlik.sqlite");
                      print(vtyolu);

                      if (await databaseExists(vtyolu)) {
                        print("var");
                        db2 = await openDatabase(vtyolu, version: 1);
                      } else {
                        print("yok");
                        db2 = await openDatabase(vtyolu,
                            version: 1, onCreate: vtOlustur);
                      }
                      var act = Map<String, dynamic>();
                      act["title"] = activ?.text;
                      act["tarih"] = date.toString();
                      act["saat"] = time.toString();
                      await db2.insert("etkinlikler", act);
                      //Navigator.pop(context);
                    },
                    child: Text('Add')),
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      Database db2;
                      Directory klasor2 =
                          await getApplicationDocumentsDirectory();
                      String vtyolu = join(klasor2.path, "etkinlik.sqlite");
                      var satir;
                      if (await databaseExists(vtyolu)) {
                        print("var");
                        db2 = await openDatabase(vtyolu);
                        List<Map<String, dynamic>> act =
                            await db2.rawQuery("SELECT * FROM etkinlikler");
                        List.generate(act.length, (index) {
                          satir = act[index];
                          print(satir["title"]);
                          print(satir["tarih"]);
                          print(satir["saat"]);
                        });
                      } else {
                        print("vt yok");
                      }

                      Navigator.pop(context, satir);
                    },
                    child: Text('Geri')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> vtOlustur(Database db, int version) async {
    await db.execute(
        "CREATE TABLE etkinlikler (title TEXT, tarih TEXT, saat TEXT)");
  }
}
