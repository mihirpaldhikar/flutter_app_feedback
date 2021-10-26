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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/services/app.service.dart';
import 'package:flutter_app_feedback/services/identifier.service.dart';

class DialogManager {
  final BuildContext context;

  DialogManager(this.context);

  final AppService _appService = AppService();
  final IdentifierService _identifierService = IdentifierService();

  void showAndroidSystemDialog() async {
    final _appInfo = await _appService.getAppInfo();
    final _deviceInfo = await _identifierService.getAndroidDeviceInformation();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('System Information'),
        content: SizedBox(
          height: MediaQuery.of(this.context).size.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text('Report Type'),
                  subtitle: Text('User initiated report'),
                ),
                ListTile(
                  title: const Text('Package name'),
                  subtitle: Text(_appInfo.packageName),
                ),
                ListTile(
                  title: const Text('Package Version'),
                  subtitle: Text(_appInfo.appBuildNumber),
                ),
                ListTile(
                  title: const Text('Package Version Name'),
                  subtitle: Text(_appInfo.appVersion),
                ),
                ListTile(
                  title: const Text('Process Name'),
                  subtitle: Text(_appInfo.packageName),
                ),
                ListTile(
                  title: const Text('Time'),
                  subtitle: Text(
                      '${DateTime.now().day}, ${DateTime.now().month}, ${DateTime.now().year}'),
                ),
                const Divider(
                  thickness: 2,
                ),
                const Text('System'),
                ListTile(
                  title: const Text('Device'),
                  subtitle: Text('${_deviceInfo!.device}'),
                ),
                ListTile(
                  title: const Text('Build Fingerprint'),
                  subtitle: Text('${_deviceInfo.fingerprint}'),
                ),
                ListTile(
                  title: const Text('Model'),
                  subtitle: Text('${_deviceInfo.model}'),
                ),
                ListTile(
                  title: const Text('Product'),
                  subtitle: Text('${_deviceInfo.product}'),
                ),
                ListTile(
                  title: const Text('SDK Version'),
                  subtitle: Text('${_deviceInfo.version.sdkInt}'),
                ),
                ListTile(
                  title: const Text('Release'),
                  subtitle: Text('${_deviceInfo.version.release}'),
                ),
                ListTile(
                  title: const Text('Incremental Version'),
                  subtitle: Text('${_deviceInfo.version.incremental}'),
                ),
                ListTile(
                  title: const Text('Codename'),
                  subtitle: Text('${_deviceInfo.version.codename}'),
                ),
                ListTile(
                  title: const Text('Board'),
                  subtitle: Text('${_deviceInfo.board}'),
                ),
                ListTile(
                  title: const Text('Brand'),
                  subtitle: Text('${_deviceInfo.brand}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
