// import 'package:bloc_pattern/model/animal_model.dart';
// import 'package:bloc_pattern/model/handling.dart';
// import 'package:dio/dio.dart';

// import '../../model/handle_model.dart';

// abstract class Service {
//   Dio dio = Dio();
//   late Response response;
// }

// abstract class SubjectService extends Service {
//   String baseurl = "https://664dcb37ede9a2b55654e96c.mockapi.io";

//   Future<SuccessSituation> getSubjects();
//   Future<SuccessSituation> addSubject(String name);
//     Future<SuccessSituation> getSubjectById(int id);
//       Future<SuccessSituation> deleteSubject(int id);
// }

// class SubjectServiceImp extends SubjectService {
//   @override
//   Future<SuccessSituation> getAnimal() async {
//     try {
//       response = await dio.get(baseurl);

//       List<AnimalModel> animals = List.generate(
//         response.data.length,
//         (index) => AnimalModel.fromMap(response.data[index]),
//       );
//       return ListOf(data: animals);
//     } catch (e) {
//       return ExceptionModel();
//     }
//   }

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





//   // if (response.statusCode == 200) {
       
//   //       List<BicycleListModel> bicycles = List.generate(
//   //         response.data['body']['bicycleList'].length,
//   //         (index) => BicycleListModel.fromJson(
//   //             response.data['body']['bicycleList'][index]),
//   //       );
//   //       return DataSuccessList(data: bicycles);
//   //     }
//   //   } on DioException catch (e) {
//   //         String? message = e.response?.data['message'];
//   //   print("iam in catch");
//   //   print(e.response?.data);

//   //     if (message == 'Username already in use') {

  