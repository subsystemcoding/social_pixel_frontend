import 'package:flutter/material.dart';

class ValidationScreen extends StatefulWidget {
  ValidationScreen({Key key}) : super(key: key);

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Validate"),
      ),
      body: ListView(
        shrinkWrap: true,
        
      ),
    );
  }
}
