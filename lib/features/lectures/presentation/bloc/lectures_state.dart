part of 'lectures_bloc.dart';
@immutable
sealed class LecturesState {}

final class LecturesLoading extends LecturesState {}

final class LecturesList extends LecturesState {
  List<LectureModel> lectures;
  
  LecturesList({required this.lectures});
}

class FailureLecturesState extends LecturesState {
  final String message;

  FailureLecturesState({required this.message});
}
