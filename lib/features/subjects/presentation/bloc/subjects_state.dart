part of 'subjects_bloc.dart';


sealed class SubjectsState {}

final class SubjectsLoading extends SubjectsState {}

final class SubjectsList extends SubjectsState {
  List<SubjectModel> subjects;
    SubjectsList({required this.subjects});

}

final class SuccessAddCode extends SubjectsState {}
class FailureSubjectsState extends SubjectsState {
  final String message;

  FailureSubjectsState({required this.message});
}
