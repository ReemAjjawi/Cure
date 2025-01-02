import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cure/services/subjects/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../model.dart';
import '../../services.dart';

part 'lectures_event.dart';
part 'lectures_state.dart';

class LecturesBloc extends Bloc<LecturesEvent, LecturesState> {
  LecturesBloc() : super(LecturesLoading()) {
    on<GetLectures>((event, emit) async {
      try {
        final connectivityResult = await Connectivity().checkConnectivity();
        print("Connectivity Result: $connectivityResult");

        if (connectivityResult.contains(ConnectivityResult.none)) {
          print("lectueer connectivity");
          print("$ConnectivityResult");
          // No internet: fetch saved lectures for the subject from Hive
          final savedLectures =
              await getSavedLectures("${event.numberOfLecture}".toString());
          print("lectueer connectivity");
          if (savedLectures.isNotEmpty) {
            emit(LecturesList(lectures: savedLectures));
          } else {
            emit(FailureLecturesState(
                message: "No internet and no saved lectures available."));
          }
          return;
        }

        // Internet is available: fetch lectures from the server
        SuccessSituation response =
            await LectureServiceImp().getLectures(event.numberOfLecture);

        if (response is DataSuccessList<LectureModel>) {
          // Save lectures to Hive for the given subject

          await saveLectures(
              "${event.numberOfLecture}".toString(), response.data);
          print("t3bttttttttttttttttttttttttttttt");
          print(response.data);
          emit(LecturesList(lectures: response.data));
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(
            message: e.message ?? "Failed to fetch lectures."));
      }
    });
  }
}

Future<List<LectureModel>> getSavedLectures(String subjectId) async {
  final box = await Hive.openBox('lecturesBox');
  final savedLectures = box.get(subjectId, defaultValue: []) as List<LectureModel>;
  return savedLectures; // Remove any null values
}

Future<void> saveLectures(String subjectId, List<LectureModel> lectures) async {
  final box = await Hive.openBox('lecturesBox');
  await box.put(subjectId, lectures);
}
