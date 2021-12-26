class Marker {
  String id;
  double latitude;
  double longitude;
  String user;

  Marker({
    this.id,
    this.latitude,
    this.longitude,
    this.user,
  });
  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      user: json['user'],
    );
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'latitude': latitude,
        'longitude': longitude,
        'user': user,
      };
}
