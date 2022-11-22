import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/widgets/home/exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/student/Student.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

bool _iconbool = false;
IconData _iconlight = Icons.light_mode_rounded;
IconData _icondark = Icons.nights_stay_rounded;

class _HomePageState extends State<HomePage> {
  logout(BuildContext context) {
    context.read<StudentStore>().logout();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    Student student = context.read<StudentStore>().currentStudent!;

    return Scaffold(
      backgroundColor: _iconbool
          ? AppTheme.themeDataDark.backgroundColor
          : AppTheme.themeData.backgroundColor,
      appBar: _buildAppBar(context, student),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              _buildExamCards(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context, student) {
    return AppBar(
      shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          0),
      elevation: 0,
      backgroundColor: AppTheme.themeData.primaryColor,
      title: Text("Welcome " + student.fname),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => UserProfile(),
              //   ),
              // );
            } else if (value == 2) {
              logout(context);
            }
          },
          color: _iconbool
              ? AppTheme.themeDataDark.dialogBackgroundColor
              : AppTheme.themeData.dialogBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image(
                image: NetworkImage("https://picsum.photos/200"),
              ),
            ),
          ),
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) {
            return [
              // PopupMenuItem<int>(
              //   value: 0,
              //   child: Padding(
              //     padding: EdgeInsets.only(right: 20, left: 10),
              //     child: Text("Profile",
              //         style: TextStyle(
              //           color: _iconbool ? Colors.white : Colors.black,
              //         )),
              //   ),
              // ),
              PopupMenuItem<int>(
                onTap: () {
                  setState(() {
                    _iconbool = !_iconbool;
                  });
                },
                value: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Theme",
                          style: TextStyle(
                            color: _iconbool ? Colors.white : Colors.black,
                          )),
                      Icon(_iconbool ? _icondark : _iconlight,
                          color: _iconbool ? Colors.white : Colors.black),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Text("Sign Out",
                      style: TextStyle(
                        color: _iconbool ? Colors.white : Colors.black,
                      )),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildExamCards(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: context
              .watch<AssignedExamStore>()
              .assignedExams
              .map((Exam exam) => ExamCard(
                    exam: exam,
                    iconBool: _iconbool,
                  ))
              .toList(),
        );
      },
    );
  }
}
