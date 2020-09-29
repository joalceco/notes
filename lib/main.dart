import 'package:flutter/material.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class Notes{
  final int id;
  final String title;
  final String body;

  Notes({this.id, this.title, this.body});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'body': body
    };
  }
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<Database> database;
  Future<List<Notes>> notes;

  Future<Database> openNotesDatabase() async{
    WidgetsFlutterBinding.ensureInitialized();
    Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, body TEXT)",
        );

      },
      version: 1,
    );
    return database;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = openNotesDatabase();
  }

  void _incrementCounter() async{
    setState(() {
      _counter++;
    });
    final nota_x = Notes(id:1,title:"prueba2", body:"pruebadebody2");
    await insertNote(nota_x);

  }

  Future<void> insertNote(Notes notes) async {
    final Database db = await database;
    await db.insert(
      'notes',
      notes.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notes>> readNotes() async{
    final Database db = await database;
    final List<Map<String, dynamic>> notes = await db.query('notes');
    return List.generate((notes.length), (i) {
      return Notes(id: notes[i]['id'],
    title:notes[i]['title'],
    body:notes[i]['body']
    );
    });
  }

  void readNotesAction(){
    setState(() {
      notes = readNotes();
    });
  }

  List<Widget> getNotesWidgets(List<Notes> note_list){
    List<Widget> widget_list = [];
    for( var note in note_list){
      widget_list.add(
        Card(child: Container(child: Row(children: [
          Expanded(child: Text(note.title)),
          Expanded(child: Text(note.body)),
        ],),),)
      );
    }
  return widget_list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: readNotesAction),
            FutureBuilder<List<Notes>>(
              future: notes,
              builder: (context,snapshot){
                if(snapshot.hasData){
//                  return ListView(children: getNotesWidgets(snapshot.data),);
                  return Container(child:ListView(children:getNotesWidgets(snapshot.data)),
                  height: 100,width: 100,);
                }else if(snapshot.hasError){
                  return Text("Error");
                }else{
                  return CircularProgressIndicator();
                }
              },
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
