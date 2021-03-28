import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class MessageManagement {
  static final MessageManagement _singleton = MessageManagement._internal();

  factory MessageManagement() {
    return _singleton;
  }

  MessageManagement._internal();

  Future<void> fetchMessages() async {
    var response = TestData.chatroomsData();
    if (!DebugMode.debug) {
      response = await GraphqlClient().query(''' 
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
    }

    var jsonResponse = jsonDecode(response)['data']['chatrooms'];
    if (jsonResponse.isNotEmpty) {
      List<Chatroom> chatrooms = List<Chatroom>.from(
        jsonResponse.map(
          (item) => Chatroom(
            id: int.parse(item['id']),
            name: item['name'],
            messages: List<Message>.from(
              item['messageSet']?.map(
                (message) => Message(
                  id: int.parse(message['id']),
                  createDate: message['timestamp'],
                  post: message['post'] != null
                      ? Post(
                          postId: int.parse(message['post']['postId']),
                          postImageLink: message['post']['image200x200'],
                        )
                      : null,
                  imageLink: message['image'],
                  text: message['text'],
                  username: message['author']['user']['username'],
                  userImage: message['author']['image'],
                ),
              ),
            ),
          ),
        ),
      );
      List<Chatroom> oldChatrooms = await getAllChatrooms();
      int newMessages = 0;

      for (int i = 0; i < chatrooms.length; i++) {
        bool matched = false;
        Chatroom chat = chatrooms[i];
        chat.newMessages = 0;
        for (int j = 0; j < oldChatrooms.length; j++) {
          Chatroom oldChat = oldChatrooms[j];
          if (chat.id == oldChat.id) {
            matched = true;
            for (int k = 0; k < chatrooms[i].messages.length; k++) {
              if (DateTime.parse(chat.messages[i].createDate)
                  .isAfter(DateTime.parse(oldChat.messageSeenTimestamp))) {
                chat.newMessages++;
                newMessages++;
              }
            }
            chat.messageSeenTimestamp = oldChat.messageSeenTimestamp;
            break;
          }
        }
        if (!matched) {
          chat.messageSeenTimestamp = chat.messages.last.createDate;
          chat.newMessages = chat.messages.length;
          newMessages += chat.newMessages;
        }
      }
      _saveMessagesToCache(chatrooms);
      _saveNewMessages(newMessages);
    }
  }

  Future<void> _saveMessagesToCache(List<Chatroom> chatrooms) async {
    final box = await Hive.openBox("chatrooms");
    for (var chat in chatrooms) {
      box.put(chat.id.toString(), chat);
    }
  }

  Future<List<Chatroom>> getAllChatrooms() async {
    final box = await Hive.openBox("chatrooms");
    List<Chatroom> chatrooms = [];
    for (int i = 0; i < box.length; i++) {
      chatrooms.add(box.getAt(i));
    }
    return chatrooms;
  }

  Future<void> _saveNewMessages(int newMessages) async {
    final box = await Hive.openBox<int>("chatroomsNewMessages");
    box.put("newMessages", newMessages);
  }

  Future<int> getNumOfNewMessages() async {
    final box = await Hive.openBox<int>('chatroomsNewMessages');
    return box.get("newMessages", defaultValue: 0);
  }

  Future<Chatroom> getChatroom(int chatroomId) async {
    List<Chatroom> chatrooms = await getAllChatrooms();
    for (var chat in chatrooms) {
      if (chat.id == chatroomId) {
        return chat;
      }
    }
    return null;
  }

  Future<void> messageSeen(int chatroomId) async {
    List<Chatroom> chatrooms = await getAllChatrooms();
    for (var chat in chatrooms) {
      if (chat.id == chatroomId) {
        chat.messageSeenTimestamp = DateTime.now().toString();
        int newMessages = await getNumOfNewMessages();
        newMessages -= chat.newMessages;
        await _saveNewMessages(newMessages);
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
