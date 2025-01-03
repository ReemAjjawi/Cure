import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cure/features/subjects/service.dart';
import 'package:cure/config/handle_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../subject_model.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsLoading()) {
    on<GetSubjects>((event, emit) async {
      try {
        // Check internet connectivity
        final connectivityResult = await Connectivity().checkConnectivity();
        print("Connectivity Result: $connectivityResult");

        if (connectivityResult.contains(ConnectivityResult.none)) {
          print("No internet connection, fetching saved subjects.");
          // Fetch saved subjects from Hive
          final savedSubjects = await getSavedSubjects();
          if (savedSubjects.isNotEmpty) {
            print(
                "Fetched ${savedSubjects.length} subjects from local storage.");
            emit(SubjectsList(subjects: savedSubjects));
          } else {
            emit(FailureSubjectsState(
                message: "No internet and no saved subjects available."));
          }
        } else {
          // Internet is available, fetch subjects from the server
          print("Fetching subjects from the server...");
          SuccessSituation response = await SubjectServiceImp().getSubjects();
          if (response is DataSuccessList<SubjectModel>) {
            print("Fetched ${response.data.length} subjects from the server.");
            // Save subjects to Hive
            await saveSubjects(response.data);
            emit(SubjectsList(subjects: response.data));
          }
        }
      } on DioException catch (e) {
        print("DioException: ${e.message}");
        emit(FailureSubjectsState(
            message: e.message ?? "Failed to fetch subjects."));
      }
    });

    // Add code to user
    on<AddCodeToUser>((event, emit) async {
      try {
        print("Adding code to user: ${event.code}");
        bool response = await SubjectServiceImp().addCodeToUser(event.code);
        print("AddCodeToUser response: $response");
        if (response) {
          emit(SuccessAddCode());
        }
      } on DioException catch (e) {
        print("DioException: ${e.message}");
        emit(FailureSubjectsState(message: e.message ?? "Failed to add code."));
      } catch (e) {
        print("Unexpected error: $e");
        emit(FailureSubjectsState(message: "An unexpected error occurred."));
      }
    });
  }
}

Future<List<SubjectModel>> getSavedSubjects() async {
  try {
    var box = await Hive.openBox('subjectsBox');
    final savedSubjects =
        box.get('subjects', defaultValue: []) as List<SubjectModel>;
    print("Loaded ${savedSubjects.length} subjects from Hive.");
    return savedSubjects;
  } catch (e) {
    print("Error accessing Hive: $e");
    return [];
  }
}

Future<void> saveSubjects(List<SubjectModel> subjects) async {
  try {
    var box = await Hive.openBox('subjectsBox');
    print("Saving ${subjects.length} subjects to Hive.");
    await box.put('subjects', subjects);
  } catch (e) {
    print("Error saving subjects to Hive: $e");
  }
}
