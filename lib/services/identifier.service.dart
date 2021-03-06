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

import 'package:device_info_plus/device_info_plus.dart';

class IdentifierService {
  /// [IdentifierService] is used to get the device information.
  IdentifierService();

  // Initialized the DeviceInfoPlugin
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// [getAndroidDeviceInformation] is used to retrieve the like
  /// [model], [manufacturer], [androidVersion], [securityPatch] and more
  /// from the Android Device.
  Future<AndroidDeviceInfo?> getAndroidDeviceInformation() async {
    try {
      if (Platform.isAndroid) {
        final androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
        return androidDeviceInfo;
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  /// [getIosDeviceInformation] is used to retrieve information like
  /// [model], [version], and much more from iOS device.
  Future<IosDeviceInfo?> getIosDeviceInformation() async {
    try {
      if (Platform.isIOS) {
        final iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
        return iosDeviceInfo;
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }
}
