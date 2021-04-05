import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class MessageManagement {
  static final MessageManagement _singleton = MessageManagement._internal();
  Chatroom _currentChatroom;
  Message _newMessage;
  factory MessageManagement() {
    return _singleton;
  }

  MessageManagement._internal();

  Future<void> fetchMessages() async {
    var response = TestData.chatroomsData();
    var authObject = await AuthRepository().getAuth();
    if (!DebugMode.debug) {
      response = await GraphqlClient().query(''' 
    query {
      chatrooms{
        id
        name
        members{
          user{
            username
          } 
          image
        }
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
          (item) {
            Chatroom chatroom = Chatroom(
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
            );
            if (!DebugMode.debug) {
              if (item['name']
                  .contains(item['members'][0]['user']['username'])) {
                if (item['members'][0]['user']['username'] ==
                    authObject.username) {
                  chatroom.name = item['members'][1]['user']['username'];
                  chatroom.userImage = item['members'][1]['image'];
                } else {
                  chatroom.name = item['members'][0]['user']['username'];
                  chatroom.userImage = item['members'][0]['image'];
                }
              }
            }
            return chatroom;
          },
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
            if (oldChat.messageSeenTimestamp != null) {
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
        }
        if (!matched) {
          if (chat.messages.isNotEmpty) {
            chat.messageSeenTimestamp = chat.messages.first.createDate;
            chat.newMessages = chat.messages.length;
            newMessages += chat.newMessages;
          }
        }
      }
      _saveMessagesToCache(chatrooms);
      _saveNewMessages(newMessages);
    }
  }

  void setCurrentChatroom(Chatroom chatroom) {
    this._currentChatroom = chatroom;
  }

  void setNewMessage(Message message) {
    this._newMessage = message;
  }

  Chatroom getCurrentChatroom() {
    Chatroom chatroom = this._currentChatroom;
    this._currentChatroom = null;
    return chatroom;
  }

  Message getNewMessage() {
    Message message = this._newMessage;
    this._newMessage = null;
    return message;
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
    _messageSeen(chatroomId);
    for (var chat in chatrooms) {
      if (chat.id == chatroomId) {
        return chat;
      }
    }
    return null;
  }

  Future<void> _messageSeen(int chatroomId) async {
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

  Future<bool> sendMessage({int chatroomId, Message message}) async {
    if (message.text != null) {
      var response = await GraphqlClient().query('''
      mutation{
        textMessage(room : $chatroomId, text : "${message.text}"){
          success
        }
      }
      ''');
      return jsonDecode(response)['data']['textMessage']['success'];
    } else if (message.post != null) {
      var response = await GraphqlClient().query('''
      mutation{
        postMessage(room : $chatroomId, post : ${message.post.postId}){
          success
        }
      }
      ''');
      return jsonDecode(response)['data']['postMessage']['success'];
    }

    var response = await GraphqlClient().muiltiPartRequest(fields: {
      'query': '''
    mutation{
      imageMessage(room : 1, image: "imageLink"){
        success
      }
    }
    ''',
    }, files: {
      'imageLink': message.imageLink
    });

    return jsonDecode(response)['data']['imageMessage']['success'];
  }
}
