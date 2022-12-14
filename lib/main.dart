import 'package:exam_app/constants/routes.dart';
import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/constants/strings.dart';
import 'package:exam_app/pages/splash.dart';
import 'package:exam_app/providers/theme_provider.dart';
import 'package:exam_app/stores/exam/assigned_exam_store.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:exam_app/stores/student/student_store.dart';
import 'package:exam_app/stores/theme/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load();
  String currentTheme = await LocalStorage.getTheme() ?? 'light';
  runApp(MyApp(theme: currentTheme));
}

class MyApp extends StatelessWidget {
  final StudentStore _studentStore = StudentStore();
  final ExamStore _examStore = ExamStore();
  final AssignedExamStore _assignedExamStore = AssignedExamStore();

  final String theme;

  MyApp({required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => _studentStore),
        Provider(create: (_) => _examStore),
        Provider(create: (_) => _assignedExamStore),
        ChangeNotifierProvider<ThemeProvider>(
            create: ((context) => ThemeProvider(theme)))
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeData,
          title: Strings.appName,
          routes: Routes.routes,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          builder: EasyLoading.init(),
        );
      }),
    );
  }
}
