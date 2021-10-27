import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/flutter_app_feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase
      .initializeApp(); // Make Sure you have initialized the firebase first.
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _homeScreen(),
            ElevatedButton(
              onPressed: () async {
                // Capture the Screen Shot and save to a variable of your choice.
                final imagePath = await FeedbackScreenshot().captureScreen(
                  screen:
                      _homeScreen(), // Set the widget tree of whom you want to take screen shot before navigation to the FeedbackScreen
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FeedbackScreen(
                      reportType:
                          'User initiated report', // Type of the report whether report is initiated by the system or the user.
                      //fromEmail: 'user@example.com', // Remove this comment if you need to set a default email in From field.
                      screenShotPath: imagePath,
                      // Use the image that we have received from about function.
                      feedbackFooterText:
                          'Some System Logs will be sent to Developer.', // This text is shown at the bottom of the Feedback Screen which describes how you will use the information.
                    ),
                  ),
                );
              },
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeScreen() {
    return SizedBox(
      height: 600,
      child: ListView.builder(
          padding: const EdgeInsets.only(
            top: 30,
            left: 30,
          ),
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              'Item $index',
              style: const TextStyle(color: Colors.black),
            );
          }),
    );
  }
}
