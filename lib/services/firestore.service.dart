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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_feedback/models/feedback.model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final String? feedbackCollectionPath;

  FirestoreService(this._firestore,
      {this.feedbackCollectionPath = 'feedbacks'});

  Future<bool> uploadUserFeedbackToFirebase(
      {required Feedback feedback}) async {
    try {
      final feedbacksCollection =
          _firestore.collection(feedbackCollectionPath!);

      final feedbackData = {
        'appName': feedback.appName,
        'packageName': feedback.packageName,
        'buildVersion': feedback.buildVersion,
        'userFeedbackData': feedback.userFeedbackData,
        'currentStateScreenShotUrl': feedback.currentStateScreenShotUrl,
        'deviceModel': feedback.deviceModel,
        'userAgent': feedback.userAgent,
        'machine': feedback.machine,
        'feedbackSubmittedOn': FieldValue.serverTimestamp(),
      };
      return false;
    } catch (error) {
      return false;
    }
  }
}
