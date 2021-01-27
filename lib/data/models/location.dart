import 'dart:convert';

class Location {
  double latitude;
  double longitude;
  Location({
    this.latitude,
    this.longitude,
  });

  Location copyWith({
    double latitude,
    double longitude,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));

  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Location && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
