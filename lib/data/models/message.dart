import 'dart:convert';

class Message {
  final String createDate;
  final String messageType;
  final String messageBody;
  final String userId;
  final String recipientId;
  Message({
    this.createDate,
    this.messageType,
    this.messageBody,
    this.userId,
    this.recipientId,
  });

  Message copyWith({
    String createDate,
    String messageType,
    String messageBody,
    String userId,
    String recipientId,
  }) {
    return Message(
      createDate: createDate ?? this.createDate,
      messageType: messageType ?? this.messageType,
      messageBody: messageBody ?? this.messageBody,
      userId: userId ?? this.userId,
      recipientId: recipientId ?? this.recipientId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createDate': createDate,
      'messageType': messageType,
      'messageBody': messageBody,
      'userId': userId,
      'recipientId': recipientId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
      createDate: map['createDate'],
      messageType: map['messageType'],
      messageBody: map['messageBody'],
      userId: map['userId'],
      recipientId: map['recipientId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(createDate: $createDate, messageType: $messageType, messageBody: $messageBody, userId: $userId, recipientId: $recipientId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message &&
        o.createDate == createDate &&
        o.messageType == messageType &&
        o.messageBody == messageBody &&
        o.userId == userId &&
        o.recipientId == recipientId;
  }

  @override
  int get hashCode {
    return createDate.hashCode ^
        messageType.hashCode ^
        messageBody.hashCode ^
        userId.hashCode ^
        recipientId.hashCode;
  }
}
