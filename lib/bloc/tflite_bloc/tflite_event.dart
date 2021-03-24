part of 'tflite_bloc.dart';

@immutable
abstract class TfliteEvent {}

class CheckImageForPerson extends TfliteEvent {
  final File imageFile;

  CheckImageForPerson(this.imageFile);
}
