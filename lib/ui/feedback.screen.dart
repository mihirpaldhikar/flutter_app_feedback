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

import 'package:flutter/material.dart';
import 'package:flutter_app_feedback/constants/string.constants.dart';
import 'package:flutter_app_feedback/managers/dialog.manager.dart';
import 'package:flutter_app_feedback/utils/validator.utils.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedback = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringConstants.navigationFeedback),
          actions: [
            IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              icon: const Icon(Icons.send),
            ),
          ],
          titleSpacing: 1.0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
          automaticallyImplyLeading: true,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          toolbarTextStyle: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 35,
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
                    TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      decoration: InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(),
                          ),
                          prefixIcon: const Icon(Icons.mail_outline_rounded)
                          //fillColor: Colors.green
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
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    TextFormField(
                      minLines: 20,
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
                        if (Platform.isAndroid) {
                          DialogManager(context).showAndroidSystemDialog();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          title: const Text('System Logs'),
                          subtitle: Text(
                            'View',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.description_outlined,
                            size: 30,
                          ),
                        ),
                      ),
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
