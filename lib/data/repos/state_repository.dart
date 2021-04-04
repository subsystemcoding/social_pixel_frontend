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
}

class StateRepo {
  static String cropRoute = '';
  static String checkHumanRoute = '';
  static String checkLocationRoute = '';
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
