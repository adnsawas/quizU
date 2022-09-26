// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileScoreAdapter extends TypeAdapter<ProfileScore> {
  @override
  final int typeId = 1;

  @override
  ProfileScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileScore(
      time: fields[0] as DateTime,
      score: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileScore obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
