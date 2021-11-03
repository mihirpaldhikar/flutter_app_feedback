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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/constants/string.constants.dart';
import 'package:flutter_app_feedback/managers/dialog.manager.dart';
import 'package:flutter_app_feedback/models/feedback.model.dart';
import 'package:flutter_app_feedback/services/app.service.dart';
import 'package:flutter_app_feedback/services/feedback.service.dart';
import 'package:flutter_app_feedback/services/identifier.service.dart';
import 'package:flutter_app_feedback/services/storage.service.dart';
import 'package:flutter_app_feedback/ui/screens/image_viewer.screen.dart';
import 'package:flutter_app_feedback/utils/random_string_generator.util.dart';
import 'package:flutter_app_feedback/utils/validator.utils.dart';

class FeedbackScreen extends StatefulWidget {
  /// [screenShotPath] set the path where the screenshot image is saved.
  /// Generally, automatically saved by [FeedbackScreen] class if it is used.
  final String screenShotPath;

  /// [feedbackFooterText] is a text shown at the bottom of the [FeedbackScreen]
  /// which explains user how you will use the feedback.
  final String feedbackFooterText;

  /// [fromEmail] is a optional parameter which is used to set default email address
  /// before navigating to the [FeedbackScreen]. Usually the email can be obtained by [FirebaseAuth]
  final String? fromEmail;

  /// [reportType] is a parameter which describes how the report was generated.
  /// It is either 'System initiated report' or 'User initiated report'.
  final String reportType;

  /// [isEmailEditable] is a parameter used to allow user to edit his email after
  /// entering to the [FeedbackScreen]
  final bool isEmailEditable;

  /// [userId] is a parameter to set the user id of the current user who is providing
  /// the feedback. This is useful for identifying the user. This value is usually
  /// retrieved from the currently authenticated user.
  final String userId;

  /// [onFeedbackSubmissionStarted] is used to do some activity when the Send Feedback button is
  /// clicked. You can show some message, dialogs or any other thing.
  final VoidCallback onFeedbackSubmissionStarted;

  /// [onFeedbackSubmitted] is used to do something after the feedback is submitted
  /// or any error occurs while submitting the feedback. It returns a [bool] value.
  /// [true] if submission is successful and [false] is submission is unsuccessful.
  final Function(bool result) onFeedbackSubmitted;

  /// [FeedbackScreen] as [StatefulWidget] for creating thr feedback screen UI.
  const FeedbackScreen({
    Key? key,
    required this.screenShotPath,
    required this.feedbackFooterText,
    required this.reportType,
    this.fromEmail = '',
    required this.onFeedbackSubmissionStarted,
    required this.onFeedbackSubmitted,
    required this.isEmailEditable,
    required this.userId,
  }) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedback = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.fromEmail!.isNotEmpty || widget.fromEmail != null) {
      setState(() {
        _emailController.text = widget.fromEmail!;
      });
    } else {
      setState(() {
        _emailController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringConstants.navigationFeedback),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final appInfo = await AppService().getAppInfo();
                  widget.onFeedbackSubmissionStarted();
                  if (Platform.isAndroid) {
                    final downloadableUrl =
                        await StorageService().uploadUserScreenshotToFirebase(
                      filePath: widget.screenShotPath,
                      imagePath:
                          'feedbackScreenshots/${RandomString().generate(10)}',
                      imageName:
                          '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().microsecondsSinceEpoch}${DateTime.now().hashCode}',
                    );
                    final result =
                        await FeedbackService(FirebaseFirestore.instance)
                            .uploadUserFeedbackToFirebase(
                      feedback: FeedbackModel(
                        appName: appInfo.appName,
                        buildVersionNumber: appInfo.appBuildNumber,
                        appVersion: appInfo.appVersion,
                        reportType: widget.reportType,
                        currentStateScreenShotUrl: downloadableUrl,
                        userFeedbackData: _feedback.text,
                        packageName: appInfo.packageName,
                        userEmail: _emailController.text,
                        userId: widget.userId,
                      ),
                      androidDeviceInfo: await IdentifierService()
                          .getAndroidDeviceInformation(),
                      iosDeviceInfo: null,
                    );

                    widget.onFeedbackSubmitted(result);
                  }

                  if (Platform.isIOS) {
                    final downloadableUrl =
                        await StorageService().uploadUserScreenshotToFirebase(
                      filePath: widget.screenShotPath,
                      imagePath:
                          'feedbackScreenshots/${RandomString().generate(10)}',
                      imageName:
                          '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().microsecondsSinceEpoch}${DateTime.now().hashCode}',
                    );
                    final result =
                        await FeedbackService(FirebaseFirestore.instance)
                            .uploadUserFeedbackToFirebase(
                      feedback: FeedbackModel(
                        appName: appInfo.appName,
                        buildVersionNumber: appInfo.appBuildNumber,
                        appVersion: appInfo.appVersion,
                        reportType: widget.reportType,
                        currentStateScreenShotUrl: downloadableUrl,
                        userFeedbackData: _feedback.text,
                        packageName: appInfo.packageName,
                        userEmail: _emailController.text,
                        userId: widget.userId,
                      ),
                      androidDeviceInfo: null,
                      iosDeviceInfo:
                          await IdentifierService().getIosDeviceInformation(),
                    );

                    widget.onFeedbackSubmitted(result);
                  }
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
          titleSpacing: 1.0,
          automaticallyImplyLeading: true,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          toolbarTextStyle: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 0,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'From: ',
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: widget.isEmailEditable,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                            ),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                            controller: _emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Email cannot be empty.";
                              } else {
                                if (!Validator().validateEmail(val)) {
                                  return "Email is not valid.";
                                } else {
                                  return null;
                                }
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    TextFormField(
                      minLines: 17,
                      style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText:
                              'Have feedback? We\'d love to hear it, but please don\'t share sensitive information.',
                          hintMaxLines: 4,
                          border: InputBorder.none),
                      maxLines: null,
                      controller: _feedback,
                      validator: (val) {
                        if (val!.characters.toString().trim().isEmpty) {
                          return "Feedback cannot be empty.";
                        } else {
                          if (val.characters.toString().trim().length < 10) {
                            return "Feedback is not valid.";
                          } else {
                            return null;
                          }
                        }
                      },
                      keyboardType: TextInputType.multiline,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      radius: 15,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ImageViewerScreen(
                                        imagePath: widget.screenShotPath)));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          top: 15,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Screenshot',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'View',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Image.file(
                              File(widget.screenShotPath),
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      radius: 15,
                      onTap: () {
                        if (Platform.isAndroid) {
                          DialogManager(context).showAndroidSystemDialog(
                              reportType: widget.reportType);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 10,
                          top: 15,
                          bottom: 13,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'System Logs',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'View',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.description_outlined,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.feedbackFooterText,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
