// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapPost.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MapPostAdapter extends TypeAdapter<MapPost> {
  @override
  final int typeId = 4;

  @override
  MapPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapPost(
      post: fields[0] as Post,
      imagePin: fields[1] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, MapPost obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.post)
      ..writeByte(1)
      ..write(obj.imagePin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
