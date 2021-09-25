import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function _handler;
  final String _text;

  AdaptiveFlatButton(this._text, this._handler);

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              _text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _handler,
          )
        : FlatButton(
            textColor: themeContext.primaryColor,
            child: Text(
              'Choose Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _handler,
          );
  }
}
