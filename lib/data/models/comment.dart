import 'dart:convert';

class Comment {
  int commentId;
  String commentContent;
  int repliedCommentId;
  int dateCreated;
  Comment({
    this.commentId,
    this.commentContent,
    this.repliedCommentId,
    this.dateCreated,
  });

  Comment copyWith({
    int commentId,
    String commentContent,
    int repliedCommentId,
    int dateCreated,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      commentContent: commentContent ?? this.commentContent,
      repliedCommentId: repliedCommentId ?? this.repliedCommentId,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentContent': commentContent,
      'repliedCommentId': repliedCommentId,
      'dateCreated': dateCreated,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Comment(
      commentId: map['commentId'],
      commentContent: map['commentContent'],
      repliedCommentId: map['repliedCommentId'],
      dateCreated: map['dateCreated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(commentId: $commentId, commentContent: $commentContent, repliedCommentId: $repliedCommentId, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Comment &&
        o.commentId == commentId &&
        o.commentContent == commentContent &&
        o.repliedCommentId == repliedCommentId &&
        o.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        commentContent.hashCode ^
        repliedCommentId.hashCode ^
        dateCreated.hashCode;
  }
}
