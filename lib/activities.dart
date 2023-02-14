import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/new_activities.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Activities extends StatefulWidget {
  List<Map<String, dynamic>> aktiviteler;
  Activities(this.aktiviteler);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  var satir;
  double deger = 0.0;
  late List<String> popgelen;
  TextEditingController activ = new TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List.generate(widget.aktiviteler.length, (index) {
      satir = widget.aktiviteler[index];
      //print(satir[index]["title"]);
      //print(satir["tarih"]);
      //print(satir["saat"]);
    }, growable: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Activities'),
        actions: [
          IconButton(
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        height: size.height * .3,
                        width: size.width * 0.85,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(color: Colors.black38),
                            ]),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: activ,
                                      cursorColor: Colors.black38,
                                      decoration: InputDecoration(
                                          hintText: 'Title: ',
                                          prefixText: ' ',
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 3))),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            DateTime? newDate =
                                                await showDatePicker(
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
                                          ).then((value) {});
                                        },
                                        icon: Icon(Icons.watch_later),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Database db2;
                                      Directory klasor2 =
                                          await getApplicationDocumentsDirectory();
                                      String vtyolu =
                                          join(klasor2.path, "etkinlik.sqlite");
                                      print(vtyolu);

                                      if (await databaseExists(vtyolu)) {
                                        print("var");
                                        db2 = await openDatabase(vtyolu,
                                            version: 1);
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
                                      Navigator.pop(context);
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              ),
                            )));
                  });
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Slider(
                  max: 10,
                  min: 0,
                  value: deger,
                  onChanged: (value) {
                    setState(() {
                      deger = value;
                    });
                  }),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: deger.toInt(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 100,
                        width: 200,
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('${satir["title"]}'),
                              Text('${satir["tarih"]}'),
                              Text('${satir["saat"]}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
