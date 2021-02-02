import 'package:flutter/material.dart';

enum ButtonStyleType {
  PurpleButton,
  DisabledPurpleButton,
}

class CustomButtons {
  static Widget standardButton(
    BuildContext context, {
    String text,
    @required Function onPressed,
    EdgeInsets margin,
    double width,
    double height,
    ButtonStyleType type = ButtonStyleType.PurpleButton,
  }) {
    var textStyle;
    var backgroundColor;
    if (type == ButtonStyleType.PurpleButton) {
      textStyle = Theme.of(context).textTheme.bodyText1;
      backgroundColor = Theme.of(context).accentColor;
    } else if (type == ButtonStyleType.DisabledPurpleButton) {
      textStyle = Theme.of(context).textTheme.bodyText2;
      backgroundColor = Theme.of(context).disabledColor;
    }
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: TextButton(
        child: Text(
          text,
          style: textStyle,
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        onPressed: onPressed,
      ),
    );
  }
}
