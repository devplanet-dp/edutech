import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/widgets/push_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
