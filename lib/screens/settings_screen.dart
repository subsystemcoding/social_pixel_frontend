import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        children: [
          Column(
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
              _buildToggleRow(context, "Pause Notifications"),
              _buildToggleRow(context, "Post Upvotes"),
              _buildToggleRow(context, "Post Comments"),
              _buildToggleRow(context, "Post Shares"),
              _buildToggleRow(context, "Post Mentions"),
              _buildToggleRow(context, "Comment Mentions"),
              _buildToggleRow(context, "Comment Replies"),
              SizedBox(
                height: 24.0,
              ),
              Text(
                "PRIVACY",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline3,
              ),
              SizedBox(
                height: 12.0,
              ),
              _buildRow(context, "Blocked Accounts"),
              _buildRow(context, "Muted Accounts"),
              SizedBox(
                height: 24.0,
              ),
              Text(
                "SECURITY",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline3,
              ),
              SizedBox(
                height: 12.0,
              ),
              _buildRow(context, "Change Password"),
              _buildRow(context, "Login Activity"),
              SizedBox(
                height: 24.0,
              ),
              Text(
                "ACCOUNT",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.headline3,
              ),
              SizedBox(
                height: 12.0,
              ),
              _buildRow(context, "Personal Information"),
              _buildRow(context, "Language"),
              _buildToggleRow(context, "Mobile Data Sver"),
              _buildToggleRow(context, "Save To CameraRoll"),
              _buildRow(context, "Request Verification"),
              _buildRow(context, "Share to Other Applications"),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildRow(BuildContext context, String text) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(text,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, height: 2.5))),
      ],
    );
  }

  Widget _buildToggleRow(BuildContext context, String text) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(text,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18.0, height: 1.9)),
        ),
        Expanded(
            child: Icon(
          Icons.toggle_on,
          color: Theme.of(context).accentColor,
          size: 50.0,
        )),
      ],
    );
  }
}
