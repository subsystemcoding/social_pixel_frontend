import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/data/models/post.dart';

part 'message.g.dart';

@HiveType(typeId: 9)
class Message {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String createDate;
  @HiveField(2)
  final String imageLink;
  @HiveField(3)
  final Post post;
  @HiveField(4)
  final String text;
  @HiveField(5)
  final String username;
  @HiveField(6)
  final String userImage;
  Message({
    this.id,
    this.createDate,
    this.imageLink,
    this.post,
    this.text,
    this.username,
    this.userImage,
  });

  Message copyWith({
    int id,
    String createDate,
    String imageLink,
    Post post,
    String text,
    String username,
    String userImage,
  }) {
    return Message(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      imageLink: imageLink ?? this.imageLink,
      post: post ?? this.post,
      text: text ?? this.text,
      username: username ?? this.username,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createDate': createDate,
      'imageLink': imageLink,
      'post': post?.toMap(),
      'text': text,
      'username': username,
      'userImage': userImage,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
      id: map['id'],
      createDate: map['createDate'],
      imageLink: map['imageLink'],
      post: Post.fromMap(map['post']),
      text: map['text'],
      username: map['username'],
      userImage: map['userImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(id: $id, createDate: $createDate, imageLink: $imageLink, post: $post, text: $text, username: $username, userImage: $userImage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message &&
        o.id == id &&
        o.createDate == createDate &&
        o.imageLink == imageLink &&
        o.post == post &&
        o.text == text &&
        o.username == username &&
        o.userImage == userImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createDate.hashCode ^
        imageLink.hashCode ^
        post.hashCode ^
        text.hashCode ^
        username.hashCode ^
        userImage.hashCode;
  }
}
