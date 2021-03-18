import 'dart:convert';

class Settings {
  final String pausenotifications;
  final String postupvotes;
  final String postcomments;
  final String postshares;
  final String postmentions;
  final String commentmentions;
  final String commentreplies;
  final String changepassword;
  final String personalinformation;
  final String language;
  final String savetocameraroll;
  final String requestverification;
  final String sharetootherapplications;
  Settings({
    this.pausenotifications,
    this.postupvotes,
    this.postcomments,
    this.postshares,
    this.postmentions,
    this.commentmentions,
    this.commentreplies,
    this.changepassword,
    this.personalinformation,
    this.language,
    this.savetocameraroll,
    this.requestverification,
    this.sharetootherapplications,
  });

  Settings copyWith({
    String pausenotifications,
    String postupvotes,
    String postcomments,
    String postshares,
    String postmentions,
    String commentmentions,
    String commentreplies,
    String changepassword,
    String personalinformation,
    String language,
    String savetocameraroll,
    String requestverification,
    String sharetootherapplications,
  }) {
    return Settings(
      pausenotifications: pausenotifications ?? this.pausenotifications,
      postupvotes: postupvotes ?? this.postupvotes,
      postcomments: postcomments ?? this.postcomments,
      postshares: postshares ?? this.postshares,
      postmentions: postmentions ?? this.postmentions,
      commentmentions: commentmentions ?? this.commentmentions,
      commentreplies: commentreplies ?? this.commentreplies,
      changepassword: changepassword ?? this.changepassword,
      personalinformation: personalinformation ?? this.personalinformation,
      language: language ?? this.language,
      savetocameraroll: savetocameraroll ?? this.savetocameraroll,
      requestverification: requestverification ?? this.requestverification,
      sharetootherapplications:
          sharetootherapplications ?? this.sharetootherapplications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pausenotifications': pausenotifications,
      'postupvotes': postupvotes,
      'postcomments': postcomments,
      'postshares': postshares,
      'postmentions': postmentions,
      'commentmentions': commentmentions,
      'commentreplies': commentreplies,
      'changepassword': changepassword,
      'personalinformation': personalinformation,
      'language': language,
      'savetocameraroll': savetocameraroll,
      'requestverification': requestverification,
      'sharetootherapplications': sharetootherapplications,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      pausenotifications: map['pausenotifications'],
      postupvotes: map['postupvotes'],
      postcomments: map['postcomments'],
      postshares: map['postshares'],
      postmentions: map['postmentions'],
      commentmentions: map['commentmentions'],
      commentreplies: map['commentreplies'],
      changepassword: map['changepassword'],
      personalinformation: map['personalinformation'],
      language: map['language'],
      savetocameraroll: map['savetocameraroll'],
      requestverification: map['requestverification'],
      sharetootherapplications: map['sharetootherapplications'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Settings(pausenotifications: $pausenotifications, postupvotes: $postupvotes, postcomments: $postcomments, postshares: $postshares, postmentions: $postmentions, commentmentions: $commentmentions, commentreplies: $commentreplies, changepassword: $changepassword, personalinformation: $personalinformation, language: $language, savetocameraroll: $savetocameraroll, requestverification: $requestverification, sharetootherapplications: $sharetootherapplications)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.pausenotifications == pausenotifications &&
        other.postupvotes == postupvotes &&
        other.postcomments == postcomments &&
        other.postshares == postshares &&
        other.postmentions == postmentions &&
        other.commentmentions == commentmentions &&
        other.commentreplies == commentreplies &&
        other.changepassword == changepassword &&
        other.personalinformation == personalinformation &&
        other.language == language &&
        other.savetocameraroll == savetocameraroll &&
        other.requestverification == requestverification &&
        other.sharetootherapplications == sharetootherapplications;
  }

  @override
  int get hashCode {
    return pausenotifications.hashCode ^
        postupvotes.hashCode ^
        postcomments.hashCode ^
        postshares.hashCode ^
        postmentions.hashCode ^
        commentmentions.hashCode ^
        commentreplies.hashCode ^
        changepassword.hashCode ^
        personalinformation.hashCode ^
        language.hashCode ^
        savetocameraroll.hashCode ^
        requestverification.hashCode ^
        sharetootherapplications.hashCode;
  }
}
