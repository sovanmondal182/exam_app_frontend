import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/providers/theme_provider.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/utils/app/app_utils.dart';
import 'package:exam_app/widgets/home/exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/student/Student.dart';

class HomePage extends StatefulWidget {
  // static bool iconBool = false;

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// bool _iconbool = false;
IconData _iconlight = Icons.light_mode_rounded;
IconData _icondark = Icons.nights_stay_rounded;

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();

  logout(BuildContext context) {
    context.read<StudentStore>().logout();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    Student student = context.read<StudentStore>().currentStudent!;

    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference.inSeconds > 2;
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          AppUtils.showToast('Please back again to exit');
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context, student),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<AssignedExamStore>()
                .getAssignedExams(student.id, student.token);
          },
          child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context, student) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

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
      title: Text("Welcome " + student.fname),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              logout(context);
            }
          },
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
              PopupMenuItem<int>(
                onTap: () {
                  // setState(() {
                  //   HomePage.iconBool = !HomePage.iconBool;
                  //   _iconbool = !_iconbool;
                  // });

                  themeProvider.toggleTheme();
                },
                value: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Theme"),
                      Icon(
                        (themeProvider.themeData == ThemeMode.dark)
                            ? _icondark
                            : _iconlight,
                        color: (themeProvider.themeData == ThemeMode.dark)
                            ? darkTheme.iconTheme.color
                            : lightTheme.iconTheme.color,
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 10),
                  child: Text("Sign Out", style: TextStyle()),
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
                    // iconBool: _iconbool,
                  ))
              .toList(),
        );
      },
    );
  }
}
