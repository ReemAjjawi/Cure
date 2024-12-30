import 'package:cure/features/dash_sub.dart/codes/response_code_model.dart';
import 'package:flutter/material.dart';

import '../../core/resources/managers/colors_manager.dart';
import '../../main.dart';

class ActivationCodes extends StatelessWidget {
  ActivationCodes({super.key, required this.codes});
  List<CodeResponse> codes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenHeight * 0.01, vertical: screenHeight * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    " الأكواد",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFEBEDEC)),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    // Aspect ratio of each item
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return ShowLectures(
                        //       subjectId: (state).subjects[index].id,
                        //       subjectName:
                        //           (state).subjects[index].name);
                        // }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15.0),
                        child: Container(
                          height: screenHeight * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                                color: const Color(0xFF749081), width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                codes[index].activation_code,
                                style: TextStyle(
                                    color: ColorsManager.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: codes.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save_alt,
                          size: 45,
                          color: Color(0xFF43584D),
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share,
                            size: 45, color: Color(0xFF43584D)))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "save",
                      style: TextStyle(color: Color(0xFF43584D)),
                    ),
                    Text("share", style: TextStyle(color: Color(0xFF43584D)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
