class MessageObj {
  final String fromName;
  final String fromUserID;
  final String message;
  final String timestamp;

  //final String urlAvatar;

  const MessageObj({
    required this.fromName,
    required this.fromUserID,
    required this.message,
    required this.timestamp,
    //required this.urlAvatar,
  });

  static MessageObj fromJson(Map<String, dynamic> json) => MessageObj(
        fromName: json['fromName'],
        fromUserID: json['fromUserID'],
        message: json['message'],
        timestamp: json['timestamp'],
        //urlAvatar: json['urlAvatar'],
      );

  Map<String, dynamic> toJson() => {
        'fromName': fromName,
        'fromUserID': fromUserID,
        'message': message,
        'timestamp': timestamp,
        //'urlAvatar': urlAvatar,
      };
}
