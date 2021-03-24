part of 'tflite_bloc.dart';

@immutable
abstract class TfliteState {}

class TfliteInitial extends TfliteState {}

class ImageChecked extends TfliteState {
  final imageLib.Image image;

  ImageChecked(this.image);
}

class ImageCheckingError extends TfliteState {}

class ImageChecking extends TfliteState {}
