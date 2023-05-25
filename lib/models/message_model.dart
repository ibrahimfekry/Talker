class MessageModel {
  String? message;
  String? id;

  MessageModel({
    this.message,
    this.id
  });

   MessageModel.fromJson(json){
     message = json['message'];
     id = json['id'];
  }
}