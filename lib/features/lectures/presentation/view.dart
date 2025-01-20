import 'package:cure/core/helper/indicator.dart';
import 'package:cure/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/managers/colors_manager.dart';
import '../../audio_pdf/view.dart';
import 'bloc/lectures_bloc.dart';

class Lectures extends StatelessWidget {
  const Lectures(
      {super.key, required this.subjectName, required this.subjectId});
  final String subjectName;
  final int subjectId;
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) =>
          LecturesBloc()..add(GetLectures(numberOfLecture: subjectId)),
      child: Builder(builder: (context) {
        return Scaffold(
            //  backgroundColor: const Color(0xFFFBFAF5),
            body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.02, vertical: screenHeight * 0.05),
            child: Column(children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    subjectName,
                    style: TextStyle(
                        color: ColorsManager.loginColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 0.02 * screenHeight),
              BlocConsumer<LecturesBloc, LecturesState>(
                listener: (context, state) {
                  if (state is FailureLecturesState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 5),
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is LecturesLoading) {
                    return const Indicator();
                  } else if (state is FailureLecturesState) {
                    return const Text("");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PdfAudioPage(
                                      lectureName: (state).lectures[index].name,
                                      subjectName: subjectName,
                                      index: (state).lectures[index].id);
                                },
                              ));
                            },
                            child: Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      //      height: screenHeight / 9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(
                                            color: const Color(0xFF749081),
                                            width: 0.5),
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.download_outlined,
                                            size: 31,
                                            color: ColorsManager.primaryColor),
                                        title: Text(
                                          (state).lectures[index].name,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorsManager.primaryColor,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: screenWidth * 0.09),
                                                child: Text("ميغا",
                                                    style: TextStyle(
                                                        color: ColorsManager
                                                            .grayColor)),
                                              ),
                                              const Spacer(),
                                              Text(" ساعات",
                                                  style: TextStyle(
                                                      color: ColorsManager
                                                          .grayColor)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: (state as LecturesList).lectures.length,
                      ),
                    );
                  }
                },
              )
            ]),
          ),
        ));
      }),
    );
  }
}
