import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/post.dart';

part 'mapPost.g.dart';

@HiveType(typeId: 4)
class MapPost {
  @HiveField(0)
  Post post;
  @HiveField(1)
  Uint8List imagePin;
  MapPost({
    this.post,
    this.imagePin,
  });

  MapPost copyWith({
    Post post,
    Uint8List imagePin,
  }) {
    return MapPost(
      post: post ?? this.post,
      imagePin: imagePin ?? this.imagePin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'post': post.toMap(),
      //'imagePin': imagePin.toMap(),
    };
  }

  factory MapPost.fromMap(Map<String, dynamic> map) {
    return MapPost(
      post: Post.fromMap(map['post']),
      //imagePin: Uint8List.fromMap(map['imagePin']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MapPost.fromJson(String source) =>
      MapPost.fromMap(json.decode(source));

  @override
  String toString() => 'MapPost(post: $post, imagePin: $imagePin)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapPost && other.post == post && other.imagePin == imagePin;
  }

  @override
  int get hashCode => post.hashCode ^ imagePin.hashCode;
}
