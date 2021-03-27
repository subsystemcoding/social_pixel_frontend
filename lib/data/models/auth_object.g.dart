// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthObjectAdapter extends TypeAdapter<AuthObject> {
  @override
  final int typeId = 7;

  @override
  AuthObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthObject()
      ..username = fields[0] as String
      ..email = fields[1] as String
      ..password = fields[2] as String
      ..token = fields[3] as String
      ..refreshToken = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, AuthObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
