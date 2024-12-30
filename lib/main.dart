import 'package:cure/features/auth/presentation/view.dart';
import 'package:cure/features/dash_sub.dart/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'config/bloc_observe_config.dart';
import 'features/dash_sub.dart/auth/presentation/view.dart';
import 'features/subjects/presentation/view.dart';

final box = Hive.box('projectBox');
late final String? token;

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('projectBox');

  runApp(const MyApp());
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
