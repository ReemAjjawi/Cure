import 'package:hive/hive.dart';

import '../../features/lectures/lecture_model.dart';

class LectureModelAdapter extends TypeAdapter<LectureModel> {
  @override
  final int typeId = 0; // Ensure this ID is unique across all your adapters.

  @override
  LectureModel read(BinaryReader reader) {
    return LectureModel(
      id: reader.readInt(),
      name: reader.readString(),
      subject_id: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, LectureModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.subject_id);
  }
}
