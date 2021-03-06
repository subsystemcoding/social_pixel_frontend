// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 6;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      gameId: fields[0] as int,
      image: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      leaderboardId: fields[4] as int,
      mapPosts: (fields[5] as List)?.cast<MapPost>(),
      pinColorHex: fields[6] as String,
      channel: fields[7] as Channel,
    )..isSubscribed = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.gameId)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.leaderboardId)
      ..writeByte(5)
      ..write(obj.mapPosts)
      ..writeByte(6)
      ..write(obj.pinColorHex)
      ..writeByte(7)
      ..write(obj.channel)
      ..writeByte(8)
      ..write(obj.isSubscribed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
