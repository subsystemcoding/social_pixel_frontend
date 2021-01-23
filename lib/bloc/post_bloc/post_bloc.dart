import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/post_management.dart';
import 'package:exif/exif.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final postManagement = PostManagement();

  PostBloc() : super(PostInitial());

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    yield PostLoading();
    String gpsPosition;

    try {
      if (event is GetPost) {
        final posts = await postManagement.fetchPosts();
        yield PostLoaded(posts);
      } else if (event is GetPostAndGame) {
        final posts = await postManagement.fetchPosts();
        yield PostLoaded(posts);
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is GetGame) {
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is SendPost) {
        if (event.addLocation) {
          final data = await readExifFromBytes(
              await new File(event.imageFile.path).readAsBytes());
          if (data.containsKey('GPS GPSLongitude')) {
            print("GPS exists");
            print(data['GPS GPSLongitude'].toString());
            print(data['GPS GPSLatitude'].toString());
            gpsPosition = data['GPS GPSLatitude'].toString() +
                ', ' +
                data['GPS GPSLongitude'].toString();
          } else {
            print("GPS does not exist");
            Position position = await _determinePosition();
            gpsPosition = position.latitude.toString() +
                ', ' +
                position.longitude.toString();
            print(position.toJson());
          }
        }
        final post = Post(
          gpsTag: gpsPosition ?? null,
          caption: event.caption,
        );
        final value =
            await postManagement.sendPost(post, PostSending.Successful);
        yield PostSent(value);
      }
    } catch (e) {
      yield PostError("Could not find posts");
    }
    // TODO: implement mapEventToState
  }
}
