import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/models/post.dart';

class MessageManagement {
  MessageManagement();

  Future<List<Message>> fetchUserList() {
    return Future.delayed(Duration(milliseconds: 100), () {
      return [];
    });
  }

  Future<dynamic> fetchMessages() async {
    var response = await GraphqlClient().query(''' 
    query {
      chatrooms{
        id
        name
        messageSet{
          id
          timestamp
          post{
            postId
            image200x200
          }
          image
          text
          author{
            user{
              username
            }
            image
          }
        }
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['chatrooms'];

    List<Chatroom> chatrooms = jsonResponse['chatrooms']
        .map(
          (item) => Chatroom(
            id: item['id'],
            name: item['name'],
            messages: item['messageSet'].map(
              (message) => Message(
                id: message['id'],
                createDate: message['timestamp'],
                post: Post(
                  postId: message['post']['postId'],
                  postImageLink: message['post']['image200x200'],
                ),
                imageLink: message['image'],
                text: message['text'],
                username: message['author']['user']['username'],
                userImage: message['author']['image'],
              ),
            ),
          ),
        )
        .toList();
    var oldChatrooms = await _getAllChatrooms();

    for (var oldChat in oldChatrooms) {
      for (var newChat in chatrooms) {
        if (newChat.id == oldChat.id) {
          newChat.messageSeenTimestamp = oldChat.messageSeenTimestamp;
          DateTime messageLastSeen =
              DateTime.parse(oldChat.messageSeenTimestamp);
          for (var message in newChat.messages) {
            DateTime messageTime = DateTime.parse(message.createDate);
            if (messageTime.isAfter(messageLastSeen)) {
              newChat.newMessages++;
            } else {
              break;
            }
          }
        }
        continue;
      }
    }

    _saveMessagesToCache(chatrooms);

    return chatrooms;
  }

  Future<void> _saveMessagesToCache(List<Chatroom> chatrooms) async {
    final box = await Hive.openBox("chatrooms");
    box.put("messages", chatrooms);
  }

  Future<List<Chatroom>> _getAllChatrooms() async {
    final box = await Hive.openBox("chatrooms");
    return box.get("messages");
  }

  Future<Chatroom> getChatroom(int chatroomId) async {
    List<Chatroom> chatrooms = await _getAllChatrooms();
    for (var chat in chatrooms) {
      if (chat.id == chatroomId) {
        return chat;
      }
    }
  }

  Future<void> messageSeen(int chatroomId) async {
    List<Chatroom> chatrooms = await _getAllChatrooms();
    for (var chat in chatrooms) {
      if (chat.id == chatroomId) {
        chat.messageSeenTimestamp = DateTime.now().toString();
        chat.newMessages = 0;
        break;
      }
    }
  }

  Future<bool> sendMessage(
      {int chatroomId, String text, int postId, String imagePath}) async {
    String mutation = "";
    var variable;
    if (text != null) {
      mutation = "textMessage";
      variable = text;
    } else if (postId != null) {
      mutation = "postMessage";
      variable = postId;
    } else if (imagePath != null) {
      mutation = "imageMessage";
      variable = imagePath;
    }
    var response = await GraphqlClient().query('''
      mutation {
        $mutation(room: $chatroomId, text: "$variable"){
          success
        }
      }
      ''');

    return jsonDecode(response)['data'][mutation]['success'];
  }
}
