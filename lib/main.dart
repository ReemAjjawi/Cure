import 'package:cure/features/auth/presentation/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'config/bloc_observe_config.dart';
import 'core/adapters/lecture_information_model_adapter.dart';
import 'core/adapters/lecture_model_adapter.dart';
import 'core/adapters/subject_model_adapter.dart';
import 'features/subjects/presentation/view.dart';
import 'package:device_info_plus/device_info_plus.dart';

final box = Hive.box('projectBox');
late final String? token;
String? deviceId;
void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  deviceId = await getAndroidId(); // Fetch the Android ID during initialization
  await Hive.initFlutter();
  await Hive.openBox('projectBox');
  Hive.registerAdapter(LectureModelAdapter()); // Register the adapter

  Hive.registerAdapter(SubjectModelAdapter()); // Register the adapter
  Hive.registerAdapter(LectureInformationModelAdapter()); // Register your adapter


  runApp(const MyApp());
}

Future<String?> getAndroidId() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidInfo = await deviceInfoPlugin.androidInfo;
  print(androidInfo.id);

  return androidInfo.id; // Unique device ID
}

late double screenWidth;

late double screenHeight;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: box.get('token') != null ? const Subjects() : const Page1(),
    );
  }
}
