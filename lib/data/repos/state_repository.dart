import 'dart:io';

import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';

enum CropState {
  ChannelCover,
  ChannelAvatar,
  GameImage,
}

class StateRepo {
  static String cropRoute = '';
  static CropState cropState;

  static Map createGameState = {
    'edit': false,
    'imageFile': null,
    'name': '',
    'desc': '',
    'posts': '',
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
      default:
    }
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
