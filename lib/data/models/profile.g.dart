// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      userId: fields[0] as int,
      username: fields[1] as String,
      userAvatarImage: fields[2] as String,
      userCoverImage: fields[3] as String,
      email: fields[4] as String,
      description: fields[5] as String,
      points: fields[6] as int,
      followers: fields[7] as int,
      createDate: fields[8] as String,
      isVerified: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.userAvatarImage)
      ..writeByte(3)
      ..write(obj.userCoverImage)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.points)
      ..writeByte(7)
      ..write(obj.followers)
      ..writeByte(8)
      ..write(obj.createDate)
      ..writeByte(9)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
