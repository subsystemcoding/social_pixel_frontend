import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/RaisedTextButton.dart';

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
          RaisedTextButton(
            backgroundColor: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            text: "Login",
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 28.0),
          //   child: TextButton(
          //     style: TextButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(25.0),
          //         ),
          //         backgroundColor: Theme.of(context).accentColor,
          //         primary: Theme.of(context).primaryColor),
          //     child: Text(
          //       "Login",
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          RaisedTextButton(
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).accentColor,
            text: "Register",
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 28.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(25.0),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey[300],
          //             blurRadius: 20.0,
          //             spreadRadius: 5.0,
          //           )
          //         ]),
          //     child: TextButton(
          //       style: TextButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(25.0),
          //           ),
          //           primary: Theme.of(context).accentColor,
          //           backgroundColor: Theme.of(context).primaryColor),
          //       child: Text(
          //         "Register",
          //         style: TextStyle(fontSize: 20),
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
