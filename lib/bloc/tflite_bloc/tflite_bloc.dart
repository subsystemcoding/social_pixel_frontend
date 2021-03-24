import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/repos/tflite_repository.dart';
import 'package:image/image.dart' as imageLib;

part 'tflite_event.dart';
part 'tflite_state.dart';

class TfliteBloc extends Bloc<TfliteEvent, TfliteState> {
  TfLiteRepository _tfLiteRepository = TfLiteRepository();
  TfliteBloc() : super(TfliteInitial());

  @override
  Stream<TfliteState> mapEventToState(
    TfliteEvent event,
  ) async* {
    yield ImageChecking();
    if (event is CheckImageForPerson) {
      final image = await _tfLiteRepository.checkHumanInPhoto(event.imageFile);
      yield ImageChecked(image);
    }
  }
}
