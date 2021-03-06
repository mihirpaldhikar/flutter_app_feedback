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
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_app_feedback/models/feedback.model.dart';

class FeedbackService {
  /// [_firestore] initializes the [FirebaseFirestore] instance.
  final FirebaseFirestore _firestore;

  /// [feedbackCollectionPath] is a optional parameter to set the default parent
  /// directory of storing the User Feedbacks in Firebase Cloud Firestore.
  /// Default is set to [feedbacks]
  final String? feedbackCollectionPath;

  /// [FeedbackService] is the main service to submit the user feedbacks to the
  /// Cloud Firestore.
  FeedbackService(
    this._firestore, {
    this.feedbackCollectionPath = 'feedbacks',
  });

  /// [uploadUserFeedbackToFirebase] is the function which takes the user feedback
  /// and all the system information and uploads it to the Cloud Firestore.
  /// This function is [Platform] dependent. Which means it automatically
  /// submits the appropriate system information based on the [Platform] on
  /// which app is running. Currently supports only [Android] & [iOS]
  Future<bool> uploadUserFeedbackToFirebase({
    required FeedbackModel feedback,
    required AndroidDeviceInfo? androidDeviceInfo,
    required IosDeviceInfo? iosDeviceInfo,
  }) async {
    try {
      if (Platform.isAndroid) {
        final feedbackData = {
          'appName': feedback.appName,
          'packageName': feedback.packageName,
          'appVersion': feedback.appVersion,
          'buildVersion': feedback.buildVersionNumber,
          'userFeedbackData': feedback.userFeedbackData,
          'currentStateScreenShotUrl': feedback.currentStateScreenShotUrl,
          'feedbackSubmittedOn': FieldValue.serverTimestamp(),
          'reportType': feedback.reportType,
          'userInformation': {
            'userId': feedback.userId,
            'email': feedback.userEmail,
          },
          'systemInformation': {
            'device': androidDeviceInfo!.device,
            'isPhysicalDevice': androidDeviceInfo.isPhysicalDevice,
            'buildFingerprint': androidDeviceInfo.fingerprint,
            'model': androidDeviceInfo.model,
            'product': androidDeviceInfo.product,
            'sdkVersion': androidDeviceInfo.version.sdkInt,
            'release': androidDeviceInfo.version.release,
            'incrementalVersion': androidDeviceInfo.version.incremental,
            'codename': androidDeviceInfo.version.codename,
            'board': androidDeviceInfo.board,
            'brand': androidDeviceInfo.brand,
          }
        };

        await _firestore
            .collection(feedbackCollectionPath!)
            .doc('android')
            .collection('feedbacks')
            .doc()
            .set(feedbackData);

        return true;
      }
      if (Platform.isIOS) {
        final feedbackData = {
          'appName': feedback.appName,
          'packageName': feedback.packageName,
          'appVersion': feedback.appVersion,
          'buildVersion': feedback.buildVersionNumber,
          'userFeedbackData': feedback.userFeedbackData,
          'currentStateScreenShotUrl': feedback.currentStateScreenShotUrl,
          'feedbackSubmittedOn': FieldValue.serverTimestamp(),
          'reportType': feedback.reportType,
          'userInformation': {
            'userId': feedback.userId,
            'email': feedback.userEmail,
          },
          'systemInformation': {
            'name': iosDeviceInfo!.name,
            'systemVersion': iosDeviceInfo.systemVersion,
            'model': iosDeviceInfo.model,
            'utsName': {
              'version': iosDeviceInfo.utsname.version,
              'release': iosDeviceInfo.utsname.release,
              'machine': iosDeviceInfo.utsname.machine,
              'nodeName': iosDeviceInfo.utsname.nodename,
              'sysName': iosDeviceInfo.utsname.sysname,
            },
            'identifierForVendor': iosDeviceInfo.identifierForVendor,
            'isPhysicalDevice': iosDeviceInfo.isPhysicalDevice,
          }
        };

        await _firestore
            .collection(feedbackCollectionPath!)
            .doc('ios')
            .collection('feedbacks')
            .doc()
            .set(feedbackData);

        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}
