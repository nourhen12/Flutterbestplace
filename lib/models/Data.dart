class Data {
  String status;
  String message;
  dynamic payload;
  Data({
    this.status,
    this.message,
    this.payload,
  });
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status: json['status'],
      message: json['message'],
      payload: json['payload'],
    );
  }
  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}
