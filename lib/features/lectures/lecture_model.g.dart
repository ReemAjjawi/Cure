// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureModelAdapter extends TypeAdapter<LectureModel> {
  @override
  final int typeId = 0;

  @override
  LectureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LectureModel(
      id: fields[0] as int,
      name: fields[1] as String,
      subject_id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LectureModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subject_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
