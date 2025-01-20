import 'dart:developer';

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

          log("---------------------------------------");
          final savedSubjects = await getSavedSubjects();

          emit(SubjectsList(subjects: savedSubjects));
        } else {
          SuccessSituation response = await SubjectServiceImp().getSubjects();
          if (response is DataSuccessList<SubjectModel>) {
            print("Fetched ${response.data.length} subjects from the server.");
            await saveSubjects(response.data);
            emit(SubjectsList(subjects: response.data));
          }
          else{
                emit(FailureSubjectsState(
            message: "Failed to fetch subjects."));
 
          }
        }

      } on DioException catch (e) {
        print("DioException: ${e.message}");
        emit(FailureSubjectsState(
            message: "Failed to fetch subjects."));
      }
      catch (e) {
        print("Unexpected error: $e");
        emit(FailureSubjectsState(message: "An unexpected error occurred."));
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
        else{
           emit(FailureSubjectsState(message: "Failed to add code, The Code is Taken or Code is not Correct"));
    
        }
      } on DioException catch (e) {
        print("DioException: ${e.message}");
        emit(FailureSubjectsState(message: "Failed to add code, The Code is Taken or Code is not Correct"));
      } catch (e) {
        print("Unexpected error: $e");
        emit(FailureSubjectsState(message: "An unexpected error occurred."));
      }
    });
  }
}

Future<List<SubjectModel>> getSavedSubjects() async {
  try {
    var box =
        await Hive.openBox<List>('subjectsBox'); // Open box with dynamic type
    final savedSubjects =
        box.get('subjects', defaultValue: [])!.cast<SubjectModel>();
    return savedSubjects;
    // return (savedSubjects ?? []).map((e) => e as SubjectModel).toList();
  } catch (e) {
    print("Error accessing Hive: $e");
    return [];
  }
}

Future<void> saveSubjects(List<SubjectModel> subjects) async {
  try {
    var box = await Hive.openBox<List<SubjectModel>>('subjectsBox');
    await box.put("subjects", subjects);
    log("=================================");

    print(box.get('subjects'));
    print("Saving ${subjects.length} subjects to Hive.");

    await box.close();
  } catch (e) {
    print("Error saving subjects to Hive: $e");
  }
}
