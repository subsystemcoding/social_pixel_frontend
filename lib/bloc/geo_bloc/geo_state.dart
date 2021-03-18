part of 'geo_bloc.dart';

@immutable
abstract class GeoState {}

class GeoInitial extends GeoState {}

class GeoPositionLoading extends GeoState {}

class GeoPositionLoaded extends GeoState {
  final Position position;

  GeoPositionLoaded(this.position);
}

class GeoPositionError extends GeoState {}
