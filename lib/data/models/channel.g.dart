// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelAdapter extends TypeAdapter<Channel> {
  @override
  final int typeId = 5;

  @override
  Channel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Channel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      subscribers: fields[3] as int,
      coverImageLink: fields[4] as String,
      avatarImageLink: fields[5] as String,
      games: (fields[6] as List)?.cast<Game>(),
      posts: (fields[7] as List)?.cast<Post>(),
      isSubscribed: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Channel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.subscribers)
      ..writeByte(4)
      ..write(obj.coverImageLink)
      ..writeByte(5)
      ..write(obj.avatarImageLink)
      ..writeByte(6)
      ..write(obj.games)
      ..writeByte(7)
      ..write(obj.posts)
      ..writeByte(8)
      ..write(obj.isSubscribed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
