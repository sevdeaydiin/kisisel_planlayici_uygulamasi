import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/login.dart';
import 'package:kisisel_planlayici_uygulamasi/edit.dart';
import 'package:kisisel_planlayici_uygulamasi/sign_up.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kisisel_planlayici_uygulamasi/menu.dart';

class Profile extends StatefulWidget {
  var satir;
  Profile(this.satir);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 40,
                  ),
                  SizedBox(height: 40),
                  Text('T.C.Number:'),
                  Text(
                    '${widget.satir["tc"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('Name:'),
                  Text(
                    '${widget.satir["name"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('LastName'),
                  Text(
                    '${widget.satir["lastname"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('Birthday: '),
                  Text(
                    '${widget.satir["birthday"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('Single/Married: '),
                  Text(
                    '${widget.satir["marital_status"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('Interest '),
                  Text(
                    '${widget.satir["interest"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  Text('Diriver Licence '),
                  Text(
                    '${widget.satir["driver_licence"]}',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                  ),
                  Divider(thickness: 4),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        Database db;
                        Directory klasor =
                            await getApplicationDocumentsDirectory();
                        String veritabyolu = join(klasor.path, "kisi.sqlite");
                        var row;
                        if (await databaseExists(veritabyolu)) {
                          print("var");
                          db = await openDatabase(veritabyolu);
                          List<Map<String, dynamic>> maps = await db.rawQuery(
                              "SELECT * FROM kisiler where tc = ${widget.satir["tc"]}");

                          List.generate(maps.length, (index) {
                            row = maps[index];
                            print(row["tc"]);
                            print(row["name"]);
                            print(row["lastname"]);
                            print(row["password"]);
                            print(row["birthday"]);
                            print(row["marital_status"]);
                            print(row["interest"]);
                            print(row["driver_licence"]);
                          });
                        } else {
                          print("vt yok");
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Edit(row)));
                      },
                      child: Text('Edit')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
