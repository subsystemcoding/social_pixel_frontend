// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatroomAdapter extends TypeAdapter<Chatroom> {
  @override
  final int typeId = 8;

  @override
  Chatroom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chatroom(
      id: fields[0] as int,
      name: fields[1] as String,
      messages: (fields[3] as List)?.cast<Message>(),
      messageSeenTimestamp: fields[4] as String,
      newMessages: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Chatroom obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.messages)
      ..writeByte(4)
      ..write(obj.messageSeenTimestamp)
      ..writeByte(5)
      ..write(obj.newMessages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatroomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
