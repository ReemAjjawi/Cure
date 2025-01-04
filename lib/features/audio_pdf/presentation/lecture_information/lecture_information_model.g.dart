// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_information_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureInformationModelAdapter
    extends TypeAdapter<LectureInformationModel> {
  @override
  final int typeId = 2;

  @override
  LectureInformationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LectureInformationModel(
      id: fields[0] as int,
      name: fields[1] as String,
      subject_id: fields[2] as int,
      audioLectureId: fields[3] as int?,
      audioLectureDownloadLink: fields[4] as String?,
      pdfLectureId: fields[5] as int?,
      pdfLectureDownloadLink: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LectureInformationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subject_id)
      ..writeByte(3)
      ..write(obj.audioLectureId)
      ..writeByte(4)
      ..write(obj.audioLectureDownloadLink)
      ..writeByte(5)
      ..write(obj.pdfLectureId)
      ..writeByte(6)
      ..write(obj.pdfLectureDownloadLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureInformationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
