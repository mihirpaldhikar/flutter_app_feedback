import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/ui/feedback.screen.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatefulWidget {
  const FeedbackApp({Key? key}) : super(key: key);

  @override
  _FeedbackAppState createState() => _FeedbackAppState();
}

class _FeedbackAppState extends State<FeedbackApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FeedbackScreen(),
    );
  }
}
