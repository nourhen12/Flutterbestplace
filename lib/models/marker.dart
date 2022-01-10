import 'package:cloud_firestore/cloud_firestore.dart';

class Marker {
  String id;
  double latitude;
  double longitude;

  Marker({
    this.id,
    this.latitude,
    this.longitude,
  });

  factory Marker.fromDocument(DocumentSnapshot doc){
    return Marker(id: doc['id'],latitude: doc['latitude'],longitude: doc['longitude']);
  }
  Marker.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    latitude = documentSnapshot["latitude"];
    longitude = documentSnapshot["longitude"];
  }

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
      };
}
