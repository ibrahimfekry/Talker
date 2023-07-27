class MessageModel {
  String? message;
  String? sendBy;

  MessageModel({
    this.message,
    this.sendBy,
  });

   MessageModel.fromJson(json){
     message = json['message'];
     sendBy = json['sendBy'];
  }
}

