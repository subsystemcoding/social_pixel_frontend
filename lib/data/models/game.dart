import 'dart:convert';

class Game {
  String image;
  String name;
  String description;
  Game({
    this.image,
    this.name,
    this.description,
  });

  Game copyWith({
    String image,
    String name,
    String description,
  }) {
    return Game(
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'description': description,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Game(
      image: map['image'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

  @override
  String toString() =>
      'Game(image: $image, name: $name, description: $description)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Game &&
        o.image == image &&
        o.name == name &&
        o.description == description;
  }

  @override
  int get hashCode => image.hashCode ^ name.hashCode ^ description.hashCode;
}
