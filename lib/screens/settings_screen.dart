import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBar2 = AppBar(
      title:
          const Text('Settings', style: TextStyle(fontSize: 20.0, height: 2.5)),
    );
    return Scaffold(
        appBar: appBar2,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 24.0,
                  ),
                  _buildHeading(context, "NOTIFICATIONS"),
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
                  _buildHeading(context, "SECURITY"),
                  SizedBox(
                    height: 12.0,
                  ),
                  _buildRow(context, "Change Password"),
                  SizedBox(
                    height: 24.0,
                  ),
                  _buildHeading(context, "ACCOUNT"),
                  SizedBox(
                    height: 12.0,
                  ),
                  _buildRow(context, "Personal Information"),
                  _buildRow(context, "Language"),
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

  Widget _buildHeading(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).primaryTextTheme.headline3,
    );
  }
}
