import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'notes.dart';

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
      join(await getDatabasesPath(), 'notes_database2.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, lat REAL, lon REAL)",
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
//    final nota_x = Notes(id:1,title:"prueba2", body:"pruebadebody2");
//    await insertNote(nota_x);

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
          body:notes[i]['body'],
          position: Position(latitude: notes[i]['lat'], longitude: notes[i]['lon'])
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
            Expanded(child: Text(note.position.latitude.toString())),
            Expanded(child: Text(note.position.longitude.toString()),),
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
        onPressed: (){
          get_note(context);

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void get_note(BuildContext context) async{
    var result = await Navigator.pushNamed(context,'/newnote');
    await insertNote(result);
  }
}


