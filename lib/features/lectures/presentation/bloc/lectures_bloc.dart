import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cure/config/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../lecture_model.dart';
import '../../service.dart';

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
          final savedLectures =
              await getSavedLectures("${event.numberOfLecture}".toString());

          print("lectueer connectivity");
          if (savedLectures.isNotEmpty) {
            emit(LecturesList(lectures: savedLectures));
          } else {
            emit(FailureLecturesState(
                message: "No internet and no saved lectures available."));
          }
        } else {
          SuccessSituation response =
              await LectureServiceImp().getLectures(event.numberOfLecture);

          if (response is DataSuccessList<LectureModel>) {
            await saveLectures(
                "${event.numberOfLecture}".toString(), response.data);

            emit(LecturesList(lectures: response.data));
          } else {
            emit(FailureLecturesState(message: "Failed to fetch lectures."));
          }
        }
      } on DioException catch (e) {
        emit(FailureLecturesState(message: "Failed to fetch lectures."));
      } catch (e) {
        print("Unexpected error: $e");
        emit(FailureLecturesState(message: "Failed to fetch lectures."));
      }
    });
  }
}

Future<List<LectureModel>> getSavedLectures(String subjectId) async {
  try {
    var box =
        await Hive.openBox<List>('lecturesBox'); // Open box with dynamic type

    final savedLectures =
        box.get(subjectId, defaultValue: [])!.cast<LectureModel>();
    print("Loaded ${savedLectures.length ?? 0} subjects from Hive.");
    return savedLectures;
  } catch (e) {
    print("Error accessing Hive: $e");
    return [];
  }
}

Future<void> saveLectures(String subjectId, List<LectureModel> lectures) async {
  try {
    var box = await Hive.openBox<List<LectureModel>>('lecturesBox');
    await box.put(subjectId, lectures);

    print(box.get(subjectId));
    log("=================================");
    print("Saving ${lectures.length} subjects to Hive.");
    // await box.clear(); // Clear existing data
    await box.close();
    // await box.addAll(subjects);
  } catch (e) {
    print("Error saving subjects to Hive: $e");
  }
}
