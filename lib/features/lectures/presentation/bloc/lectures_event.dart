// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lectures_bloc.dart';

@immutable
sealed class LecturesEvent {}

class GetLectures extends LecturesEvent {
  int numberOfLecture;
  GetLectures({
    required this.numberOfLecture,
  });
}
