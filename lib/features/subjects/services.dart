import 'package:cure/config/app_url.dart';
import 'package:dio/dio.dart';

import '../../config/header_config.dart';
import '../../services/subjects/handle_model.dart';
import 'model.dart';

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
      return DataSuccessList<SubjectModel>(data: subjects);
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

//   @override
//   Future<SuccessSituation> addCodeToUser(String code)async {

//  try {

//       response = await dio.post(AppUrl.baseUrl + AppUrl.addCodeToUser,
//           options: HeaderConfig.getHeader(useToken: true),
//           data: code);
//       return DataSuccessObject<LectureModel>(data: lec);
//     }

//     on DioException catch (e) {
//       throw e;
//     }
//   }

  // }
}

//   @override
//   Future<SuccessSituation> createNewAniml(String name) async {
//     try {
//       response = await dio.post(baseurl, data: {"name": name});
//       AnimalModel animalModel = AnimalModel.fromMap(response.data);
//       return animalModel;
//     } catch (e) {
//       print(e);
//       return ExceptionModel();
//     }
//   }


//   @override
//       Future<SuccessSituation> getSubjectById(int id) async {
//     print(
//         '${AppUrl.baseUrl}/${AppUrl.getBicyclesByCategory}?category=$categoryName');

//     print("hiiiii");
//     try {
//       Response response = await dio.get(
//           '${AppUrl.baseUrl}/${AppUrl.getBicyclesByCategory}?category=$categoryName',
//           options: HeaderConfig.getHeader(useToken: true));
//       print("hiiiii");
//       List<BicycleModel> bicycles = List.generate(
//         response.data['body'].length,
//         (index) => BicycleModel.fromJson(response.data['body'][index]),
//       );
//       // List<BicycleEntity> bicycle =
//       //     bicycles.map<BicycleEntity>((bicycle) => bicycle).toList();
//       return DataSuccessList(data: bicycles);
//        } on DioException catch (e) {
//       throw ServerException(message: "try again");
//     }
   
  
//     }
     


//   Future <SuccessSituation> deleteSubject(int id)async{
// try { 
//   response = await dio.delete(baseurl);
// } catch (e) {
//   print(e); 
// }
//   }







  

// }





  // if (response.statusCode == 200) {
       
  //       List<BicycleListModel> bicycles = List.generate(
  //         response.data['body']['bicycleList'].length,
  //         (index) => BicycleListModel.fromJson(
  //             response.data['body']['bicycleList'][index]),
  //       );
  //       return DataSuccessList(data: bicycles);
  //     }
  //   } on DioException catch (e) {
  //         String? message = e.response?.data['message'];
  //   print("iam in catch");
  //   print(e.response?.data);

  //     if (message == 'Username already in use') {

  