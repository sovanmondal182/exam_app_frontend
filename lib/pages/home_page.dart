import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/widgets/home/exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      backgroundColor: _iconbool
          ? AppTheme.themeDataDark.primaryColorDark
          : AppTheme.themeData.primaryColorDark,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          // color: _iconbool
          //     ? AppTheme.themeDataDark.primaryColorDark
          //     : AppTheme.themeData.primaryColorDark,
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

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      backgroundColor: _iconbool
          ? AppTheme.themeDataDark.primaryColor
          : AppTheme.themeData.primaryColor,
      title: Text("Welcome"),
      actions: [
        PopupMenuButton(
          color: _iconbool
              ? AppTheme.themeDataDark.primaryColor
              : AppTheme.themeData.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image(
                image: NetworkImage('https://picsum.photos/250?image=9'),
              ),
            ),
          ),
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Text("Profile",
                      style: TextStyle(
                        color: _iconbool ? Colors.white : Colors.black,
                      )),
                ),
              ),
              PopupMenuItem<int>(
                onTap: () {
                  setState(() {
                    _iconbool = !_iconbool;
                    print(_iconbool);
                    print(_icondark.toString());
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
                onTap: () {
                  logout(context);
                },
                value: 4,
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
        // IconButton(
        //   icon: Icon(Icons.logout),
        //   onPressed: () => logout(context),
        // )
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
