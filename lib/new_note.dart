

import 'package:flutter/material.dart';
import 'notes.dart';
import 'package:geolocator/geolocator.dart';



class new_note_Screen extends StatelessWidget{

  Notes create_note(String title, String body, Position position){
    final nota_x = Notes(id:null,title:title, body:body, position:position);
    return nota_x;
//    await insertNote(nota_x);
  }


  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nueva Nota"),),
      body: Center(
        child: ListView(children: [
          Text("Titulo:"),
          TextField(controller: titleController,),
          Text("Mensaje"),
          TextField(controller: bodyController,),
          RaisedButton(child: Text("crear nota",),onPressed: () async {

            LocationPermission permission = await requestPermission();
            Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            Notes nota = create_note(titleController.text, bodyController.text, position);

            Navigator.pop(context,nota);
          },)
        ],),
      ),
    );
  }


}