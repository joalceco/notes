import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'new_note.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => MyHomePage(title: 'Notas'),
        '/newnote':(context) => new_note_Screen(),
      },
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
