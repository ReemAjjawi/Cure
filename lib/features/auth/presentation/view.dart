import 'package:cure/features/auth/model.dart';
import 'package:cure/features/auth/presentation/bloc/login_bloc.dart';
import 'package:cure/features/auth/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:cure/core/resources/managers/colors_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/indicator.dart';
import '../../../main.dart';
import '../../subjects/presentation/view.dart';
import 'bloc/login_event.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final formKey = GlobalKey<FormState>(); // Define a GlobalKey for the Form
    TextEditingController code = TextEditingController();
    TextEditingController phone = TextEditingController();
    final ValueNotifier<bool> isObscuredNotifier = ValueNotifier<bool>(true);

    void toggleVisibility() {
      isObscuredNotifier.value = !isObscuredNotifier.value;
    }

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.05, vertical: screenHeight * 0.05),
            child: SingleChildScrollView(
              child: Form(
                key: formKey, // Assign the Form key
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 0.02 * screenHeight),
                    Container(
                      height: screenHeight / 4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/frame.png")),
                      ),
                    ),
                    SizedBox(height: 0.06 * screenHeight),
                    SizedBox(
                      height: 0.06 * screenHeight,
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        cursorColor: ColorsManager.secondaryBColor,
                        decoration: InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: "رقم الجوال",
                          hintStyle: TextStyle(color: ColorsManager.hintColor),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ColorsManager.BorderColor,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: ColorsManager.BorderColor,
                              )),
                          hoverColor: ColorsManager.secondaryBColor,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "يرجى إدخال رقم الجوال";
                          } else if (value.length != 10) {
                            return "يجب أن يتكون رقم الجوال من 10 أرقام";
                          } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return "يرجى إدخال أرقام فقط";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 0.06 * screenHeight),
                    SizedBox(
                      height: 0.06 * screenHeight,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: isObscuredNotifier,
                          builder: (context, isObscured, child) {
                            return TextFormField(
                              controller: code,
                              cursorColor: ColorsManager.secondaryBColor,
                              obscureText: isObscured ? true : false,
                              decoration: InputDecoration(
                                hintTextDirection: TextDirection.rtl,
                                hintText: "كود الاشتراك ",
                                hintStyle:
                                    TextStyle(color: ColorsManager.hintColor),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: ColorsManager.BorderColor,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: ColorsManager.BorderColor,
                                    )),
                                hoverColor: ColorsManager.secondaryBColor,
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: ColorsManager.secondaryBColor,
                                  ),
                                  onPressed: toggleVisibility,
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: screenHeight / 5,
                    ),
                    BlocConsumer<LoginBloc, LogInClassState>(
                      listener: (context, state) {
                        if (state is LogInSuccessState) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Subjects();
                          }));
                        } else if (state is LogInFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is InitialStateLogIn) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.secondaryColor,
                              minimumSize: Size(
                                0.8 * screenWidth,
                                0.065 * screenHeight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(LogInEvent(
                                    LogInModel(
                                        phone_number: phone.text,
                                        password: "00-B0-D0-63-C2-26",
                                        code: code.text)));
                              }
                            },
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: ColorsManager.loginColor,
                              ),
                            ),
                          );
                        } else if (state is LogInLoadingState) {
                          return const Indicator();
                        } else if (state is LogInSuccessState) {
                          return const SizedBox();
                        } else {
                         return 
                            
                            
                            SizedBox(
                        height: 300,
                        child: Column(
                          children: [
                           ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.secondaryColor,
                              minimumSize: Size(
                                0.8 * screenWidth,
                                0.065 * screenHeight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(LogInEvent(
                                    LogInModel(
                                        phone_number: phone.text,
                                        password: "00-B0-D0-63-C2-26",
                                        code: code.text)));
                              }
                            },

                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: ColorsManager.loginColor,
                              ),
                            ),
                          ),

                          ],
                        ),
                      );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "التواصل مع الدعم",
                            style: TextStyle(
                              color: ColorsManager.loginColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Icon(Icons.call, color: ColorsManager.loginColor),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
        );
      }),
    );
  }
}
