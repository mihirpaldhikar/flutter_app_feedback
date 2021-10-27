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

import 'package:flutter_app_feedback/models/app.model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppService {

  /// [AppService] is used to retrieve the App Build Information.
  AppService();

  /// [getAppInfo] is used to retrieve the information like [appVersion],
  /// [packageName], [buildNumber] and much more from the current build of the app.
  Future<AppModel> getAppInfo() async {
    final PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    return AppModel(
      appName: _packageInfo.appName,
      appVersion: _packageInfo.version,
      packageName: _packageInfo.packageName,
      appBuildNumber: _packageInfo.buildNumber,
    );
  }
}
