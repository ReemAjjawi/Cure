// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsEvent {}

class GetSubjects extends SubjectsEvent {}

class AddCodeToUser extends SubjectsEvent {
  String code;
  AddCodeToUser({
    required this.code,
  });
}
