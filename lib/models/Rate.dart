class Rate {
  String id;
  String Iduser;
  double rating ;

  Rate({
    this.id,
    this.Iduser,
    this.rating,
  });

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      id: json['id'],
      Iduser: json['Iduser'],
      rating: json['rating'],
    );
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'Iduser': Iduser,
        'rating': rating,
      };
}
