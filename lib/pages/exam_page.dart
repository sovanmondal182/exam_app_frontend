import 'dart:async';
import 'package:exam_app/models/exam/Exam.dart';
import 'package:exam_app/pages/home_page.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:exam_app/utils/app/app_utils.dart';
import 'package:exam_app/utils/face_detection/face_detection_util.dart';
import 'package:exam_app/widgets/exam/exam_navigation_buttons.dart';
import 'package:exam_app/widgets/exam/exam_timer.dart';
import 'package:exam_app/widgets/exam/exam_warning_alert.dart';
import 'package:exam_app/widgets/exam/question_button.dart';
import 'package:exam_app/widgets/exam/question_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../constants/routes.dart';
import '../models/student/Student.dart';
import '../stores/exam/assigned_exam_store.dart';
import '../stores/student/student_store.dart';

// TODO: Disable Screenshot

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
  Exam? exam;
  CountdownController? _countdownController;
  var count = 0;

  List<CameraDescription>? _cameras;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  XFile? lastImage;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCameras();
    FaceDetectionUtil.initialize();
    timer = Timer.periodic(Duration(seconds: 5),
        (Timer t) => [_onPictureClicked(), _onAITapped()]);
    disableCapture().then((value) => print("Capture Disabled"));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController!.dispose();
    FaceDetectionUtil.close();
    _countdownController!.start();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed &&
        !context.read<ExamStore>().didLeaveExam) {
      context.read<ExamStore>().didLeaveExam = true;
      count = count + 1;
      if (count >= 5) {
        super.dispose();
        Navigator.pop(context);
        Student student = context.read<StudentStore>().currentStudent!;

        context.read<StudentStore>().login(student);
        context
            .read<AssignedExamStore>()
            .getAssignedExams(student.id, student.token);

        Navigator.pushReplacementNamed(context, Routes.home);
      }
      print('paused');
      _countdownController!.pause();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ExamWarningAlert(),
      ).then((value) {
        context.read<ExamStore>().didLeaveExam = false;
        ++context.read<ExamStore>().leaveExamCount;
        print('resumed');

        _countdownController!.resume();
      });
    }
  }

  disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> initCameras() async {
    try {
      _cameras = await availableCameras();
      _cameraController =
          CameraController(_cameras![1], ResolutionPreset.medium);

      _cameraController?.setFlashMode(FlashMode.off);

      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } catch (e) {
      debugPrint("Failed to initialize camera: $e");
      AppUtils.showToast(
        "Failed to initialize cameras, please make sure to give necessary permissions",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    exam = context.watch<ExamStore>().currentExam;
    _countdownController = context.read<ExamStore>().countdownController;
    _countdownController!.start();
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  QuestionWidget(),
                  SizedBox(height: 20),
                  ExamNavigationButtons(onAI: _onAITapped),
                  SizedBox(height: 30),
                  _buildInfoWidget(),
                  SizedBox(height: 30),
                  _buildQuestionButtons(),
                  SizedBox(height: 30),
                  _buildVideoSection(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(exam!.name),
      actions: [
        Row(
          children: [
            Icon(Icons.timer),
            SizedBox(width: 5),
            ExamTimer(),
          ],
        )
      ],
    );
  }

  _buildInfoWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: Color(0xff9fe6a0),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Answered',
          style: TextStyle(
            fontFamily: "assets/fonts/Roboto-Medium.ttf",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 35),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: Color(0xff132c33),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Text(
          'Unanswered',
          style: TextStyle(
            fontFamily: "assets/fonts/Roboto-Medium.ttf",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  _buildQuestionButtons() {
    return Center(
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        physics: NeverScrollableScrollPhysics(),
        children: () {
          List<Widget> widgets = [];

          for (int i = 0; i < exam!.questions!.length; i++) {
            widgets.add(QuestionButton(questionNo: i));
          }

          return widgets;
        }(),
      ),
    );
  }

  _buildCameraStream() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Container(
            padding: EdgeInsets.all(6),
            child: CameraPreview(_cameraController!),
          );
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _buildVideoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 10,
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          // padding: EdgeInsets.all(6),
          alignment: Alignment.bottomRight,
          height: 150,
          width: 150,
          child: _buildCameraStream(),
        ),
      ],
    );
  }

  _onPictureClicked() async {
    try {
      await _initializeControllerFuture;
      lastImage = await _cameraController!.takePicture();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _onAITapped() async {
    if (lastImage == null) {
      print("Failed to capture image");
      return;
    }
    String path = lastImage!.path;
    List<Face> faces = await FaceDetectionUtil.detectFromImagePath(path);

    final CheatingStatus cheatingStatus =
        FaceDetectionUtil.detectCheating(faces.length > 0 ? faces[0] : null);

    if (cheatingStatus == CheatingStatus.Detected) {
      AppUtils.showToast("CHEATING DETECTED");
      count = count + 1;
      print(count);
      if (count >= 5) {
        super.dispose();
        Navigator.pop(context);
        Student student = context.read<StudentStore>().currentStudent!;

        context.read<StudentStore>().login(student);
        context
            .read<AssignedExamStore>()
            .getAssignedExams(student.id, student.token);

        Navigator.pushReplacementNamed(context, Routes.home);
      }
      print('CHEATING DETECTED');
    } else if (cheatingStatus == CheatingStatus.NotDetected) {
      print('NO CHEATING DETECTED');
    } else {
      AppUtils.showToast("Failed to detect face");
      print('Failed to detect face');
      count = count + 1;
      if (count >= 5) {
        super.dispose();
        Navigator.pop(context);
        Student student = context.read<StudentStore>().currentStudent!;

        context.read<StudentStore>().login(student);
        context
            .read<AssignedExamStore>()
            .getAssignedExams(student.id, student.token);

        Navigator.pushReplacementNamed(context, Routes.home);
      }
    }
  }
}
