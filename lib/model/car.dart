class Car {
  String name;
  double latitude;
  double longitude;
  int speed;
  String status;
  String id;

  Car(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.speed,
      required this.status,
      required this.id});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      name: json['name'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      speed: json['speed'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'status': status,
      'id': id,
    };
  }
}
