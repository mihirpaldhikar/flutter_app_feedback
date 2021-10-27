![Flutter Feedback Banner](https://raw.githubusercontent.com/imihirpaldhikar/flutter_app_feedback/main/assets/flutter_app_feedback_banner.png)

![Pub Version](https://img.shields.io/pub/v/flutter_app_feedback?color=g&label=Package%20Version&logo=flutter&logoColor=blue&style=flat)
![Dart Analyze Workflow](https://github.com/imihirpaldhikar/flutter_app_feedback/actions/workflows/dart-analyze.yml/badge.svg)
![Dart Analyze Workflow](https://github.com/imihirpaldhikar/flutter_app_feedback/actions/workflows/pub-publish.yml/badge.svg)
![GitHub contributors](https://img.shields.io/github/contributors/imihirpaldhikar/flutter_app_feedback)
![GitHub commit activity](https://img.shields.io/github/commit-activity/w/imihirpaldhikar/flutter_app_feedback)

# Flutter App Feedback

Taking feedback from the user made easy!

Simply integrate `flutter_app_feedback` package into your Flutter project and you are ready to take
feedbacks.

`flutter_app_feedback` uses firebase as a default backend for taking the feedback.

Users feedbacks are stored in the [Cloud Firestore](https://firebase.google.com/docs/firestore) with
the collection named `feedbacks` but you can also choose your own collection where you want to save
the feedbacks.

This package also takes the screenshot of the current state of the app before taking to feedback UI.
The screenshots are saved into the [Firebase Storage](https://firebase.google.com/docs/storage) by
default with in the folder named `feedback_screenshots`.

In order to use this package, you need to integrate the Firebase with your Flutter Project. The docs
regarding this can be found over [Flutter Firebase](https://firebase.flutter.dev).

## Feedback Screen

<img src="https://raw.githubusercontent.com/imihirpaldhikar/flutter_app_feedback/main/assets/feedback_screen.png" width="200">

## Usage

### Import

``` dart
import 'package:flutter_app_feedback/flutter_app_feedback.dart';

```

### To Capture Screenshot

``` dart
// Capture the Screen Shot and save to a variable of your choice.
  await FeedbackScreenshot().captureScreen(
  // Set the widget tree of whom you want to take screen shot before navigation to the FeedbackScreen
    screen: _homeScreen(),
  );

```

### Use ```FeedbackScreen```

``` dart
   FeedbackScreen(
   
     // Type of the report whether report is initiated by the
     // system or the user.
     reportType: 'User initiated report',
     
     // if you need to set a default email in From Email field.
     fromEmail: 'user@example.com',
    
     // Use the image that we have received from about function.
     screenShotPath: imagePath,
     
     // This text is shown at the bottom of the Feedback Screen
     // which describes how you will use the information.
     feedbackFooterText:
         'Some System Logs will be sent to Developer.',
     
     // Handel when the feedback submission is started
     onFeedbackSubmissionStarted: () {
       print('Feedback Submission Started');
     },
     
     // Handel when feedback submission is completed.
     onFeedbackSubmitted: (bool result) {
       if (result) {
         print('Feedback Submitted Successfully');
       } else {
         print('Error in submitting the Feedback');
       }
     },
   ),
```

### Example

``` dart
  ElevatedButton(
    onPressed: () async {
      // Capture the Screen Shot and save to a variable of your choice.
      final imagePath = await FeedbackScreenshot().captureScreen(
        // Set the widget tree of whom you want to take screen shot before
        // navigation to the FeedbackScreen
        screen: _homeScreen(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => FeedbackScreen(
            // Type of the report whether report is initiated by the
            // system or the user.
            reportType: 'User initiated report',

            // if you need to set a default email in From Email field.
            fromEmail: 'user@example.com',

            // Use the image that we have received from about function.
            screenShotPath: imagePath,

            // This text is shown at the bottom of the Feedback Screen
            // which describes how you will use the information.
            feedbackFooterText:
                'Some System Logs will be sent to Developer.',

            // Handel when the feedback submission is started
            onFeedbackSubmissionStarted: () {
              print('Feedback Submission Started');
            },

            // Handel when feedback submission is completed.
            onFeedbackSubmitted: (bool result) {
              if (result) {
                print('Feedback Submitted Successfully');
              } else {
                print('Error in submitting the Feedback');
              }
            },
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

## License

![GitHub](https://img.shields.io/github/license/imihirpaldhikar/flutter_app_feedback?color=g)

## Author

[Mihir Paldhikar](https://github.com/imihirpaldhikar)

## Credits

Thanks to all the contributers of this package and the packages that this project uses to make
things work!
