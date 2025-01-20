import 'package:cure/core/helper/indicator.dart';
import 'package:cure/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/resources/managers/colors_manager.dart';
import '../../lectures/presentation/view.dart';
import 'bloc/subjects_bloc.dart';

class Subjects extends StatefulWidget {
  const Subjects({super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  TextEditingController newCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    screenHeight = MediaQuery.sizeOf(context).height;

    return BlocProvider(
      create: (context) => SubjectsBloc()..add(GetSubjects()),
      child: Builder(builder: (context) {
        return Scaffold(
          //  backgroundColor: const Color(0xFFFBFAF5),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.02,
                  vertical: screenHeight * 0.05),
              child: Column(children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      " المقررات",
                      style: TextStyle(
                          color: ColorsManager.loginColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 0.02 * screenHeight),
                BlocConsumer<SubjectsBloc, SubjectsState>(
                  listener: (context, state) {
                    if (state is FailureSubjectsState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.message),
                        duration: const Duration(seconds: 5),
                      ));
                    } else if (state is SuccessAddCode) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const Subjects();
                      }));
                      showModalBottomSheet(
                        isScrollControlled:
                            true, // Allows the modal to adjust height dynamically
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40.0),
                          ),
                        ),
                        backgroundColor: ColorsManager.secondaryColor,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom, // Adjusts for the keyboard
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "تم إضافة المواد بنجاح !",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: ColorsManager.loginColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: ColorsManager.loginColor,
                                  ),
                                  const SizedBox(height: 16.0),
                                  Container(
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/onlys.png"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                               ///   const SizedBox(height: 24.0),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SubjectsLoading) {
                      return const Align(
                          alignment: Alignment.bottomCenter,
                          child: Indicator());
                    } else if (state is SubjectsList) {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Lectures(
                                      subjectName:
                                          (state).subjects[index].name!,
                                      subjectId: (state).subjects[index].id);
                                }));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: screenHeight / 9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                        color: const Color(0xFF749081),
                                        width: 0.5),
                                  ),
                                  child: ListTile(
                                    trailing: Container(
                                      width: screenWidth * 0.09,
                                      height: screenHeight * 0.08,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/books.png")),
                                      ),
                                    ),
                                    title: Text(
                                      (state).subjects[index].name!,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorsManager.primaryColor,
                                          fontSize: 14),
                                    ),
                                    leading: Icon(
                                      Icons.download_outlined,
                                      color: ColorsManager.primaryColor,
                                      size: 26,
                                    ),
                                    subtitle: Text(
                                        ' ${state.subjects[index].countOfLectures} عدد المحاضرات',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: ColorsManager.grayColor)),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: (state).subjects.length,
                        ),
                      );
                    } else if (state is FailureSubjectsState) {
                      return Text("");
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ]),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: FloatingActionButton(
              backgroundColor: ColorsManager.priaryBColor,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled:
                      true, // Allows the modal to adjust its height for the keyboard
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40.0),
                    ),
                  ),
                  backgroundColor: ColorsManager.secondaryColor,
                  builder: (_) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context)
                            .viewInsets
                            .bottom, // Avoids keyboard overlap
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the modal adapts to its content
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenHeight * 0.01,
                                  vertical: screenHeight * 0.02,
                                ),
                                child: Center(
                                  child: Text(
                                    "الرجاء إدخال الكود الجديد",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsManager.loginColor,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: ColorsManager.loginColor,
                              ),
                              SizedBox(height: 0.02 * screenHeight),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: SizedBox(
                                  height: 0.076 * screenHeight,
                                  width: 0.8 * screenWidth,
                                  child: TextFormField(
                                    controller: newCode,
                                    cursorColor: ColorsManager.secondaryBColor,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintTextDirection: TextDirection.rtl,
                                      hintStyle:
                                          const TextStyle(color: Colors.black),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color:
                                              ColorsManager.BorderColorNewCode,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color:
                                              ColorsManager.BorderColorNewCode,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 13.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      color: ColorsManager.BorderStudentColor,
                                      width: 1,
                                    ),
                                    backgroundColor: ColorsManager.priaryBColor,
                                    minimumSize: Size(
                                      0.8 * screenWidth,
                                      0.06 * screenHeight,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);

                                    context
                                        .read<SubjectsBloc>()
                                        .add(AddCodeToUser(code: newCode.text));
                                    newCode.clear();
                                  },
                                  child: Text(
                                    "التحقق",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: ColorsManager.loginColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "التواصل مع الدعم",
                                      style: TextStyle(
                                          color: ColorsManager.loginColor),
                                    ),
                                    Icon(
                                      Icons.call,
                                      color: ColorsManager.loginColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                // Your onPressed action here
              },
              // Your onPressed action here

              shape: RoundedRectangleBorder(
                  side: BorderSide(color: ColorsManager.BorderStudentColor),
                  borderRadius: BorderRadius.circular(65)),
              child: Icon(
                Icons.add,
                color: ColorsManager.loginColor,
                size: 38,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    newCode.dispose(); // Dispose of the player when no longer needed
    super.dispose();
  }
}
