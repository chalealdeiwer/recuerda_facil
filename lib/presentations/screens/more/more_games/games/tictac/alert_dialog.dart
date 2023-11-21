// import 'dart:io';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showAlert({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
  required Function onPressed,
}) async {
  if (Platform.isIOS) {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => onPressed(),
                  child: Text(buttonText),
                )
              ],
            ));
  }

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title,style: const TextStyle(fontSize:35),),
      content: Text(message,style: const TextStyle(fontSize: 25),),
      actions: [
        FilledButton(
          onPressed: () => onPressed(),
          child: Text(buttonText,style: const TextStyle(fontSize: 25),),
        )
      ],
    ),
  );
}