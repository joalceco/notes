import 'package:geolocator/geolocator.dart';

class Notes{
  final int id;
  final String title;
  final String body;
  final Position position;


  Notes({this.id, this.title, this.body, this.position});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'body': body,
      'lat': position.latitude,
      'lon': position.longitude,
    };
  }
}
