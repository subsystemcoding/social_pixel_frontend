import 'dart:convert';

import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 3)
class Location {
  @HiveField(0)
  double latitude;
  @HiveField(1)
  double longitude;
  @HiveField(2)
  String address;
  Location({
    this.latitude,
    this.longitude,
    this.address,
  });

  Location copyWith({
    double latitude,
    double longitude,
    String address,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));

  @override
  String toString() =>
      'Location(latitude: $latitude, longitude: $longitude, address: $address)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Location &&
        o.latitude == latitude &&
        o.longitude == longitude &&
        o.address == address;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ address.hashCode;
}
