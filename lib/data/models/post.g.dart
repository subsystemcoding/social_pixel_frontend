// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 0;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      postId: fields[0] as int,
      userName: fields[1] as String,
      userAvatarLink: fields[2] as String,
      datePosted: fields[3] as String,
      postImageLink: fields[4] as String,
      caption: fields[5] as String,
      otherUsers: (fields[6] as List)?.cast<Profile>(),
      upvotes: fields[7] as int,
      commentCount: fields[8] as int,
      comments: (fields[9] as List)?.cast<Comment>(),
      location: fields[10] as Location,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userAvatarLink)
      ..writeByte(3)
      ..write(obj.datePosted)
      ..writeByte(4)
      ..write(obj.postImageLink)
      ..writeByte(5)
      ..write(obj.caption)
      ..writeByte(6)
      ..write(obj.otherUsers)
      ..writeByte(7)
      ..write(obj.upvotes)
      ..writeByte(8)
      ..write(obj.commentCount)
      ..writeByte(9)
      ..write(obj.comments)
      ..writeByte(10)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
