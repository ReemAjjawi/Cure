// import 'package:cure/core/helper/indicator.dart';
// import 'package:cure/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../core/resources/managers/colors_manager.dart';
// import '../../lectures/presentation/view.dart';
// import 'bloc/subjects_bloc.dart';

// class Subjects extends StatefulWidget {
//   const Subjects({super.key});

//   @override
//   State<Subjects> createState() => _SubjectsState();
// }

// class _SubjectsState extends State<Subjects> {
//   TextEditingController name1 = TextEditingController();

//   TextEditingController name2 = TextEditingController();

//   TextEditingController name3 = TextEditingController();

//   TextEditingController name4 = TextEditingController();

//   TextEditingController name5 = TextEditingController();

//   TextEditingController name6 = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//        screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;

//     return BlocProvider(
//       create: (context) => SubjectsBloc()..add(GetSubjects()),
//       child: Builder(builder: (context) {
//         return Scaffold(
//           //  backgroundColor: const Color(0xFFFBFAF5),
//           body: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: screenHeight * 0.02,
//                   vertical: screenHeight * 0.05),
//               child: Column(children: [
//                  Align(
//                   alignment: Alignment.topRight,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       " المقررات",
//                       style:
//                           TextStyle(color: ColorsManager.loginColor,fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 0.02 * screenHeight),
//                 BlocConsumer<SubjectsBloc, SubjectsState>(
//                   listener: (context, state) {
//                     if (state is FailureSubjectsState) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text(state.message),
//                         duration: const Duration(seconds: 5),
//                       ));
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is SubjectsLoading) {
//                       return const Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Indicator());
//                     } else {
//                       return Expanded(
//                         child: ListView.builder(
//                           itemBuilder: (context, index) {
//                             return InkWell(
//                               onTap: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (context) {
//                                   return Lectures(
//                                       subjectName:
//                                           (state).subjects[index].name!,
//                                       subjectId: index + 1);
//                                 }));
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Container(
//                                   height: screenHeight / 9,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(9),
//                                     border: Border.all(
//                                         color: const Color(0xFF749081),
//                                         width: 0.5),
//                                   ),
//                                   child: ListTile(
//                                     trailing: Container(
//                                       width: screenWidth * 0.09,
//                                       height: screenHeight * 0.08,
//                                       decoration: const BoxDecoration(
//                                         image: DecorationImage(
//                                             image: AssetImage(
//                                                 "assets/images/books.png")),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       (state).subjects[index].name!, textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: ColorsManager.primaryColor,
//                                           fontSize: 14),
//                                     ),
//                                     leading: Icon(
//                                       Icons.download_outlined,
//                                       color: ColorsManager.primaryColor,
//                                       size: 26,
//                                     ),
//                                     subtitle: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           Padding(
//   padding: EdgeInsets.only(
//                                                     left: screenWidth * 0.09),                                            child: Text(
//                                               "ميغا500",
//                                               style: TextStyle(
//                                                   color: ColorsManager.grayColor),
//                                             ),
//                                           ),
//                                           // const Spacer(),
//                                           Text(" 7 ساعات",
//                                               style: TextStyle(
//                                                   color:
//                                                       ColorsManager.grayColor)),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           itemCount: (state as SubjectsList).subjects.length,
//                         ),
//                       );
//                     }
//                   },
//                 )
//               ]),
//             ),
//           ),
//           floatingActionButton: Padding(
//             padding: const EdgeInsets.only(bottom: 45.0),
//             child: FloatingActionButton(
//               backgroundColor: ColorsManager.priaryBColor,
//               onPressed: () {
//                 showModalBottomSheet(
//                     isScrollControlled: true,
//                     context: context,
//                     shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(40.0),
//                     )),
//                     backgroundColor: ColorsManager.secondaryColor,
//                     builder: (context) {
//                       return Form(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             //    crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenHeight * 0.01,
//                                       vertical: screenHeight * 0.02),
//                                   child: Center(
//                                     child: Text(
//                                       "الرجاء إدخال الكود الجديد",
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: ColorsManager.loginColor),
//                                     ),
//                                   )),
//                               Divider(
//                                 thickness: 1,
//                                 color: ColorsManager.loginColor,
//                               ),
//                               SizedBox(
//                                 height: 0.02 * screenHeight,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(18.0),
//                                 child: Form(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name1,
//                                           textDirection: TextDirection.rtl,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name2,
//                                           textDirection: TextDirection.rtl,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name3,
//                                           textDirection: TextDirection.rtl,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name4,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           textDirection: TextDirection.rtl,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name5,
//                                           textDirection: TextDirection.rtl,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           obscureText: true,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           keyboardType: TextInputType.number,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: screenWidth * 0.11,
//                                         height: screenHeight * 0.07,
//                                         child: TextFormField(
//                                           onChanged: (val) {
//                                             if (val.length == 1) {
//                                               FocusScope.of(context)
//                                                   .nextFocus();
//                                             }
//                                           },
//                                           onSaved: (pin1) {},
//                                           controller: name6,
//                                           textDirection: TextDirection.rtl,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineLarge,
//                                           textAlign: TextAlign.center,
//                                           cursorColor:
//                                               ColorsManager.secondaryBColor,
//                                           keyboardType: TextInputType.number,
//                                           obscureText: true,
//                                           inputFormatters: [
//                                             LengthLimitingTextInputFormatter(1),
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           decoration: InputDecoration(
//                                             border:
//                                                 const OutlineInputBorder(), // Default border
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .secondaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                               borderSide: BorderSide(
//                                                   color: ColorsManager
//                                                       .priaryBColor,
//                                                   width: 2.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: screenHeight * 0.05,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 13.0),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     side: BorderSide(
//                                         color: ColorsManager.BorderStudentColor,
//                                         width: 1),
//                                     backgroundColor: ColorsManager.priaryBColor,
//                                     minimumSize: Size(
//                                       0.8 * screenWidth,
//                                       0.06 * screenHeight,
//                                     ), // Set minimum width and height
//                                     // primary: Colors.blue, // Background color
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           10.0), // Change the radius here
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);

//                                     // context.read<SubjectsBloc>().add(
//                                     //     AddCodeToUser(
//                                               //  code: name1.text +
//                                               //   name2.text +
//                                               //   name3.text +
//                                               //   name4.text +
//                                               //   name5.text +
//                                               //   name6.text
//                                     //        ));

                          

//                                     showModalBottomSheet(
//                                         isScrollControlled: true,
//                                         context: context,
//                                         shape: const RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.vertical(
//                                           top: Radius.circular(40.0),
//                                         )),
//                                         backgroundColor:
//                                             ColorsManager.secondaryColor,
//                                         builder: (context) {
//                                           return SingleChildScrollView(
//                                             child: Column(
//                                               //    crossAxisAlignment: CrossAxisAlignment.end,
//                                               children: [
//                                                 Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal:
//                                                                 screenHeight *
//                                                                     0.01,
//                                                             vertical:
//                                                                 screenHeight *
//                                                                     0.02),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "تم إضافة المواد بنجاح ! ",
//                                                         style: TextStyle(
//                                                             fontSize: 18,
//                                                             color: ColorsManager
//                                                                 .loginColor),
//                                                       ),
//                                                     )),
//                                                 Divider(
//                                                   thickness: 1,
//                                                   color:
//                                                       ColorsManager.loginColor,
//                                                 ),
//                                                 SizedBox(
//                                                   height: 0.06 * screenHeight,
//                                                 ),
//                                                 Container(
//                                                   height: screenHeight / 8,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     image: DecorationImage(
//                                                         image: AssetImage(
//                                                             "assets/images/onlys.png")),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 0.1 * screenHeight,
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         });
//                                     // Your onPressed action here
//                                   },
//                                   child: Text(
//                                     "التحقق",
//                                     style: TextStyle(
//                                         color: ColorsManager.loginColor),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "التواصل مع الدعم",
//                                       style: TextStyle(
//                                           color: ColorsManager.loginColor),
//                                     ),
//                                     Icon(
//                                       Icons.call,
//                                       color: ColorsManager.loginColor,
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     });
//                 // Your onPressed action here
//               },
//               // Your onPressed action here

//               shape: RoundedRectangleBorder(
//                   side: BorderSide(color: ColorsManager.BorderStudentColor),
//                   borderRadius: BorderRadius.circular(65)),
//               child: Icon(
//                 Icons.add,
//                 color: ColorsManager.loginColor,
//                 size: 38,
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
