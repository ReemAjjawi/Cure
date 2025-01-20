import 'package:cure/config/app_url.dart';
import 'package:dio/dio.dart';

import '../../config/header_config.dart';
import '../../config/handle_model.dart';
import 'subject_model.dart';

abstract class Service {
  Dio dio = Dio();
  late Response response;
}

abstract class SubjectService extends Service {
  Future<DataSuccessList<SubjectModel>> getSubjects();
  Future<bool> addCodeToUser(String code);
  //   Future<SuccessSituation> getSubjectById(int id);
  //     Future<SuccessSituation> deleteSubject(int id);
}

class SubjectServiceImp extends SubjectService {
  @override
  Future<DataSuccessList<SubjectModel>> getSubjects() async {
    try {
      response = await dio.get(AppUrl.baseUrl + AppUrl.subjects,
          options: HeaderConfig.getHeader(useToken: true));
      print("iam in subjects");
      print(response.data);
      List<SubjectModel> subjects = List.generate(
        response.data['subjects'].length,
        (index) => SubjectModel.fromMap(response.data['subjects'][index]),
      );

      print("subjects");
      print(subjects);

         if (response.statusCode == 200 || response.statusCode == 201) {
                return DataSuccessList<SubjectModel>(data: subjects);

      }
      else{
  
        throw Exception(" try again later.");
      
      }
    } on DioException catch (e) {
      print("error");
      rethrow;
    }
  }

  @override
  Future<bool> addCodeToUser(String code) async {
    try {
      response = await dio.post(AppUrl.baseUrl + AppUrl.addCodeToUser,
          data: {"code": code},
          options: HeaderConfig.getHeader(useToken: true));
      print("iam in subjects");
      print(response.data);

      print("addCodeToUser");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("error");
      rethrow;
    }
  }


}
