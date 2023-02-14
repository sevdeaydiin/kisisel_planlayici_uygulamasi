import 'package:flutter/material.dart';
import 'package:kisisel_planlayici_uygulamasi/activities.dart';
import 'package:kisisel_planlayici_uygulamasi/login.dart';
import 'package:kisisel_planlayici_uygulamasi/profiles.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Menu extends StatefulWidget {
  var name;
  Menu({this.name});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer'),
      ),
      body: Center(
        child: Text('Hoş Geldin'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.pink.shade900),
              accountName: Text('Name:'),
              accountEmail: Text('${widget.name}'),
            ),
            ListTile(
              onTap: () async {
                Database db2;
                Directory klasor2 = await getApplicationDocumentsDirectory();
                String vtyolu = join(klasor2.path, "etkinlik.sqlite");
                var satir;
                if (await databaseExists(vtyolu)) {
                  print("var");
                  db2 = await openDatabase(vtyolu);
                  List<Map<String, dynamic>> act =
                      await db2.rawQuery("SELECT * FROM etkinlikler");
                  List yeni = await db2.query("etkinlikler");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Activities(act)));
                } else {
                  print("vt yok");
                }
              },
              title: Text('Etkinliklerim'),
              leading: Icon(Icons.accessibility_new),
            ),
            ListTile(
              onTap: () async {
                Database db;
                Directory klasor = await getApplicationDocumentsDirectory();
                String veritabyolu = join(klasor.path, "kisi.sqlite");
                var satir;
                if (await databaseExists(veritabyolu)) {
                  print("var");
                  db = await openDatabase(veritabyolu);
                  List<Map<String, dynamic>> maps = await db
                      .rawQuery("SELECT * FROM kisiler where tc = ${tc?.text}");

                  List.generate(maps.length, (index) {
                    satir = maps[index];
                    print(satir["tc"]);
                    print(satir["name"]);
                    print(satir["lastname"]);
                    print(satir["password"]);
                    print(satir["birthday"]);
                    print(satir["marital_status"]);
                    print(satir["interest"]);
                    print(satir["driver_licence"]);
                  });
                } else {
                  print("vt yok");
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile(satir)));
              },
              title: Text('Profilim'),
              leading: Icon(Icons.person),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              title: Text('Çıkış Yap'),
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
    );
  }
}
