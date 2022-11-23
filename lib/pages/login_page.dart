import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/constants/strings.dart';
import 'package:exam_app/models/student/Student.dart';
import 'package:exam_app/network/student_apis.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/utils/app/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isIdValid = true;
  bool isPasswordValid = true;

  _validateInputFields() {
    setState(() {
      isIdValid = _idController.text.length >= 10;
      isPasswordValid = _passwordController.text.length >= 8;
    });
  }

  _loginPressed(BuildContext context) async {
    _validateInputFields();

    if (!isIdValid || !isPasswordValid) {
      return;
    }

    try {
      AppUtils.showLoading("Logging in..");
      Student student = await StudentApi.login(
        _idController.text,
        _passwordController.text,
      );

      context.read<StudentStore>().login(student);
      context
          .read<AssignedExamStore>()
          .getAssignedExams(student.id, student.token);
      AppUtils.dismissLoading();
      Navigator.pushReplacementNamed(context, Routes.home);
    } catch (e) {
      AppUtils.dismissLoading();
      AppUtils.showToast(e.toString());
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();

    // _idController.text = "63736ebf5ab865e02d343134";
    // _idController.text = "637e023a8b676e059b66e310";
    // _passwordController.text = "12345678";

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
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_app.png',
                      scale: 1.5,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.themeData.highlightColor,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  bottom: 10.0,
                ),
                child: TextField(
                  key: Key(Strings.idFieldKey),
                  controller: _idController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      size: 30,
                    ),
                    label: Text(
                      'Login ID',
                    ),
                    labelStyle: TextStyle(fontSize: 20),
                    errorText: isIdValid ? null : Strings.idFieldError,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextField(
                  key: Key(Strings.passwordFieldKey),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 30,
                    ),
                    label: Text(
                      Strings.passwordFieldHint,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                    errorText:
                        isPasswordValid ? null : Strings.passwordFieldError,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => _loginPressed(context),
                key: Key(Strings.loginButtonKey),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: AppTheme.themeDataDark.highlightColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      Strings.loginButtonText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
