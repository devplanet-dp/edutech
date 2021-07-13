import 'dart:io';
import 'dart:math';

import 'package:edutech/ui/widgets/push_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final formatCurrency = new NumberFormat.simpleCurrency(locale: 'hi_IN');

showErrorMessage(BuildContext context, String message) {
  return PushNotification.of(context)
      .show(NotificationContent(title: 'Oops', body: message, isError: true));
}

showSuccessMessage(
    {BuildContext context, String message, String title = 'Success'}) {
  return PushNotification.of(context)
      .show(NotificationContent(title: title, body: message, isError: false));
}

String removeFirstWord(String word) {
  if (word.length > 0) {
    int i = word.indexOf(" ") + 1;
    String str = word.substring(i);
    return str;
  }
  return word;
}

extension ParseToString on Object {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

void launchInstaProfile(String userName) async {
  var url = 'https://www.instagram.com/$userName/';
  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}
