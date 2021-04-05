import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/tflite_bloc/tflite_bloc.dart';
import 'package:socialpixel/data/repos/state_repository.dart';
import 'package:socialpixel/widgets/custom_buttons.dart';

class CheckHumanScreen extends StatefulWidget {
  CheckHumanScreen({Key key}) : super(key: key);

  @override
  _CheckHumanScreenState createState() => _CheckHumanScreenState();
}

class _CheckHumanScreenState extends State<CheckHumanScreen> {
  var imageFile;
  @override
  void initState() {
    super.initState();
    imageFile = StateRepo.getImageFromState();
    print("Printing Image file from check humna");
    print(imageFile);
    BlocProvider.of<TfliteBloc>(this.context)
        .add(CheckImageForPerson(this.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body:
              BlocListener<TfliteBloc, TfliteState>(listener: (context, state) {
        // TODO: implement listener
        //
        print(state);
        if (state is ImageChecked) {
          if (state.image == null) {
            print("Found no humans");
            StateRepo.createGameState['eligible'] = true;
            Navigator.of(context).pushNamed(StateRepo.checkHumanRoute);
          }
        }
      }, child: BlocBuilder<TfliteBloc, TfliteState>(
        builder: (context, state) {
          if (state is ImageChecked) {
            if (state.image != null) {
              return _buildImageCheck();
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ))),
    );
  }

  Widget _buildImageCheck() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
              "It is not allowed to post a picture of any person in this app. Please take another picture."),
        ),
        SizedBox(
          height: 12,
        ),
        Center(
          child: CustomButtons.standardButton(context, text: "Okay",
              onPressed: () {
            var route = StateRepo.goBackRoute;
            Navigator.of(context).popUntil(ModalRoute.withName(route));
          }),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
