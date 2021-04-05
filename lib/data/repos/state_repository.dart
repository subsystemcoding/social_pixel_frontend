import 'dart:io';

import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/post.dart';

enum CropState {
  ChannelCover,
  ChannelAvatar,
  GameImage,
  PostImage,
  Capture,
}

class StateRepo {
  static String cropRoute = '';
  static String checkHumanRoute = '';
  static String checkLocationRoute = '';
  static String goBackRoute = '';
  static CropState cropState;

  static Map createGameState = {
    'imageFile': null,
    'name': '',
    'desc': '',
    'posts': List<MapPost>(),
    'postImage': null,
    'location': null,
    'eligible': false,
  };

  static Map createChannelState = {
    'name': '',
    'desc': '',
    'coverImageFile': null,
    'avatarImageFile': null,
    'rooms': List<Chatroom>(),
    'games': List<Game>(),
  };

  static Map capturePost = {
    'location': null,
    'imageFile': null,
  };

  static void addImageFromCrop(File imageFile) {
    switch (cropState) {
      case CropState.ChannelCover:
        createChannelState['coverImageFile'] = imageFile;
        break;
      case CropState.ChannelAvatar:
        createChannelState['avatarImageFile'] = imageFile;
        break;
      case CropState.GameImage:
        createGameState['imageFile'] = imageFile;
        break;
      case CropState.PostImage:
        createGameState['postImage'] = imageFile;
        break;
      case CropState.Capture:
        capturePost['imageFile'] = imageFile;
        break;
      default:
    }
  }

  static File getImageFromState() {
    switch (cropState) {
      case CropState.ChannelCover:
        return createChannelState['coverImageFile'];
        break;
      case CropState.ChannelAvatar:
        return createChannelState['avatarImageFile'];
        break;
      case CropState.GameImage:
        return createGameState['imageFile'];
        break;
      case CropState.PostImage:
        return createGameState['postImage'];
        break;
      case CropState.Capture:
        return capturePost['imageFile'];
        break;
      default:
    }
  }

  static void gameStateClear() {
    createGameState = {
      'imageFile': null,
      'name': '',
      'desc': '',
      'posts': List<MapPost>(),
      'postImage': null,
      'location': null,
      'eligible': false,
    };
  }

  static void channelStateClear() {
    createGameState = {
      'edit': false,
      'imageFile': null,
      'name': '',
      'desc': '',
      'posts': '',
    };
  }
}
