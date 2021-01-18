import 'dart:convert';

class Channel {
  final int id;
  final String name;
  final String description;
  final int subscribers;
  final String coverImageLink;
  final String avatarImageLink;
  Channel({
    this.id,
    this.name,
    this.description,
    this.subscribers,
    this.coverImageLink,
    this.avatarImageLink,
  });

  Channel copyWith({
    int id,
    String name,
    String description,
    int subscribers,
    String coverImageLink,
    String avatarImageLink,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subscribers: subscribers ?? this.subscribers,
      coverImageLink: coverImageLink ?? this.coverImageLink,
      avatarImageLink: avatarImageLink ?? this.avatarImageLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subscribers': subscribers,
      'coverImageLink': coverImageLink,
      'avatarImageLink': avatarImageLink,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Channel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      subscribers: map['subscribers'],
      coverImageLink: map['coverImageLink'],
      avatarImageLink: map['avatarImageLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Channel(id: $id, name: $name, description: $description, subscribers: $subscribers, coverImageLink: $coverImageLink, avatarImageLink: $avatarImageLink)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Channel &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.subscribers == subscribers &&
        o.coverImageLink == coverImageLink &&
        o.avatarImageLink == avatarImageLink;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        subscribers.hashCode ^
        coverImageLink.hashCode ^
        avatarImageLink.hashCode;
  }
}
