import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/message.dart';

part 'chatroom.g.dart';

@HiveType(typeId: 8)
class Chatroom {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String name;
  @HiveField(3)
  final List<Message> messages;
  @HiveField(4)
  String messageSeenTimestamp;
  @HiveField(5)
  int newMessages;
  @HiveField(6)
  String userImage;
  Chatroom({
    this.id,
    this.name,
    this.messages,
    this.messageSeenTimestamp,
    this.newMessages,
    this.userImage,
  });

  Chatroom copyWith({
    int id,
    String name,
    List<Message> messages,
    String messageSeenTimestamp,
    int newMessages,
    String userImage,
  }) {
    return Chatroom(
      id: id ?? this.id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
      messageSeenTimestamp: messageSeenTimestamp ?? this.messageSeenTimestamp,
      newMessages: newMessages ?? this.newMessages,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'messages': messages?.map((x) => x?.toMap())?.toList(),
      'messageSeenTimestamp': messageSeenTimestamp,
      'newMessages': newMessages,
      'userImage': userImage,
    };
  }

  factory Chatroom.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Chatroom(
      id: map['id'],
      name: map['name'],
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      messageSeenTimestamp: map['messageSeenTimestamp'],
      newMessages: map['newMessages'],
      userImage: map['userImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chatroom.fromJson(String source) =>
      Chatroom.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chatroom(id: $id, name: $name, messages: $messages, messageSeenTimestamp: $messageSeenTimestamp, newMessages: $newMessages, userImage: $userImage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Chatroom &&
        o.id == id &&
        o.name == name &&
        listEquals(o.messages, messages) &&
        o.messageSeenTimestamp == messageSeenTimestamp &&
        o.newMessages == newMessages &&
        o.userImage == userImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        messages.hashCode ^
        messageSeenTimestamp.hashCode ^
        newMessages.hashCode ^
        userImage.hashCode;
  }
}
