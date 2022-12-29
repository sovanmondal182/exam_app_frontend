import 'package:exam_app/constants/app_theme.dart';
import 'package:exam_app/models/exam/Question.dart';
import 'package:exam_app/pages/home_page.dart';
import 'package:exam_app/providers/theme_provider.dart';
import 'package:exam_app/stores/exam/exam_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class QuestionWidget extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Observer(
          builder: (context) {
            int currentQuesNo = context.watch<ExamStore>().currentQuestionNo;
            Question? currentQues = context.watch<ExamStore>().currentQuestion;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currentQuesNo + 1}.  ',
                      style: TextStyle(
                        fontFamily: "assets/fonts/Roboto-Medium.ttf",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        currentQues!.title,
                        style: TextStyle(
                          fontFamily: "assets/fonts/Roboto-Medium.ttf",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ..._buildOptions(currentQues, currentQuesNo, context),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildOptions(
    Question question,
    int currentQues,
    BuildContext context,
  ) {
    List<Widget> optionList = [];
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    question.options.forEach((key, value) {
      optionList.add(
        RadioListTile(
          value: key,
          title: Text(
            value,
            style: TextStyle(
              fontFamily: "assets/fonts/Roboto-Medium.ttf",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          activeColor: (themeProvider.themeData == ThemeMode.dark)
              ? Colors.white
              : Colors.blueGrey,
          groupValue: context.watch<ExamStore>().answers![currentQues],
          onChanged: (String? val) {
            context.read<ExamStore>().setAnswer(currentQues, val);
          },
        ),
      );
    });

    return optionList;
  }
}
