import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48.0,
          ),
          Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 40.0,
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                "Settings",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
            ],
          ),
          SizedBox(
            height: 24.0,
          ),
          Text(
            "NOTIFICATIONS",
            textAlign: TextAlign.left,
            style: Theme.of(context).primaryTextTheme.headline3,
          ),
          SizedBox(
            height: 12.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "Pause notifications",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline4,
              )),
              Expanded(
                  child: Icon(
                Icons.toggle_on,
                color: Theme.of(context).accentColor,
                size: 50.0,
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "Post comments",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline4,
              )),
              Expanded(
                  child: Icon(
                Icons.toggle_on,
                color: Theme.of(context).accentColor,
                size: 50.0,
              )),
            ],
          )
        ],
      ),
    ));
  }
}
