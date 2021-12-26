class Marker {
  String id;
  double latitude;
  double longitude;

  Marker({
    this.id,
    this.latitude,
    this.longitude,
  });
  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'latitude': latitude,
        'longitude': longitude,
      };
}
