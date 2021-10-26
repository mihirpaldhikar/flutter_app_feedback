import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/ui/feedback.screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
