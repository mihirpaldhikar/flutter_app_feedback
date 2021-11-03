/*
 * Copyright 2021 Mihir Paldhikar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 * OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class FeedbackScreenshot {
  /// [context] required to handle the function execution
  final BuildContext context;

  /// [FeedbackScreenshot] is used to capture the current state of the screen.
  FeedbackScreenshot(this.context);

  // Initialize the Screenshot Controller.
  final ScreenshotController _screenshotController = ScreenshotController();

  /// [captureScreen] captures the current screen and saves in the applicationDirectory.
  /// Returns a path where the screenshot is saved.
  /// Return type is [String]
  Future<String> captureScreen({
    required Widget screen,
  }) async {
    try {
      final screenShot = await _screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Theme.of(context),
            home: screen,
          ),
        ),
      );
      final directory = await getApplicationDocumentsDirectory();
      final image = File(
          '${directory.path}/${DateTime.now().microsecond}${DateTime.now().hashCode}.png');
      image.writeAsBytes(screenShot);
      return image.path;
    } catch (error) {
      rethrow;
    }
  }
}
