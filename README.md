![Flutter Feedback Banner](https://raw.githubusercontent.com/imihirpaldhikar/flutter_app_feedback/main/assets/flutter_app_feedback_banner.svg)

# Flutter App Feedback

Taking feedback from the user made easy!

Simply integrate `flutter_app_feedback` package into your Flutter project and you are ready to take feedbacks.

`flutter_app_feedback` uses firebase as a default backend for taking the feedback.

Users feedbacks are stored in the [Cloud Firestore](https://firebase.google.com/docs/firestore) with the collection named `feedbacks` but you can also choose your own collection where you want to save the feedbacks.

This package also takes the screenshot of the current state of the app before taking to feedback UI. The screenshots are saved into the [Firebase Storage](https://firebase.google.com/docs/storage) by default with in the folder named `feedback_screenshots`.

In order to use this package, you need to integrate the Firebase with your Flutter Project. The docs regarding this can be found over [Flutter Firebase](https://firebase.flutter.dev).

<center>
<img src="https://github.com/imihirpaldhikar/flutter_app_feedback/blob/main/assets/feedback_screen.png?raw=true" width="200">
</center>

## Example

```dart

ElevatedButton( // You can use any Widget.
    onPressed: () async {
       // Capture the Screen Shot and save to a variable of your choice.
        final imagePath = await FeedbackScreenshot().captureScreen(
          screen:_homeScreen(), // Set the widget tree of whom you want to take screen shot before navigation to the FeedbackScreen
        ),

        Navigator.push(context,MaterialPageRoute(
                    builder: (BuildContext context) => FeedbackScreen(
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
            
```

Full Example can be found in [main.dart](./example/lib/main.dart)

### Currently Supported Features

- [✔️] Take Screenshot 
- [✔️] Take Feedback from user 
- [✔️] View System as well as App Information 
- [✔️] View Screenshot 
- [✔️] Upload the System information as well as app information 
- [❌] Upload the logcat i.e logs of the app  
- [❌] Edit Screenshot  
