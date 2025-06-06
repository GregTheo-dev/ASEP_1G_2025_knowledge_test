import 'dart:math';

import 'package:flutter/material.dart';
import 'questions.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assessment Practice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, int> selectedAnswers = {};
 // int currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // important to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int start = 0;
    int end = (start + 30 > questions.length) ? questions.length : start + 30;
    List<Question> currentQuestions = questions.sublist(start, end);
    final random = Random();
    List<Question> copy = List.from(currentQuestions);
    copy.shuffle(random);
    List<Question> randomQuestions = [];
    randomQuestions = copy.take(30).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Εξάσκηση Ερωτήσεων')),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ...List.generate(randomQuestions.length, (index) {
              final question = randomQuestions[index];
              final globalIndex = start + index;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          question.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...List.generate(question.options.length, (optIdx) {
                        Color? color;
                        if (selectedAnswers.containsKey(globalIndex)) {
                          if (optIdx == question.correctIndex) {
                            color = Colors.green;
                          } else if (optIdx == selectedAnswers[globalIndex]) {
                            color = Colors.red;
                          }
                        }
                        return ListTile(
                          title: Text(question.options[optIdx]),
                          tileColor: color,
                          onTap: () {
                            setState(() {
                              selectedAnswers[globalIndex] = optIdx;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Τέλος ερωτήσεων", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
