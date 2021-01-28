import 'package:socialpixel/data/models/message.dart';

class MessageManagement {
  MessageManagement();

  Future<List<Message>> fetchUserList() {
    return Future.delayed(Duration(seconds: 1), () {
      return [];
    });
  }

  Future<List<Message>> fetchMessages() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        Message(
          createDate: "02:46",
          messageType: "text",
          messageBody: "hehe",
          userId: '001',
          recipientId: '002',
        ),
        Message(
          createDate: "02:47",
          messageType: "text",
          messageBody: "okay gtg bye",
          userId: '001',
          recipientId: '002',
        ),
        Message(
          createDate: "02:47",
          messageType: "text",
          messageBody: "okay cya",
          userId: '002',
          recipientId: '001',
        )
      ];
    });
  }
}
