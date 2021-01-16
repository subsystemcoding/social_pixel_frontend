import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/raised_container.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafbfd),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 208,
            height: 208,
            child: Image(
              image: NetworkImage(
                  "https://cdn.logo.com/hotlink-ok/logo-social.png"),
            ),
          ),
          Text(
            "socialpixel.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 40,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          RaisedContainer(
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                  primary: Theme.of(context).primaryColor),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedContainer(
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  primary: Theme.of(context).accentColor),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
