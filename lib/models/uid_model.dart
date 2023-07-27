class UidModel {
  String? uid;
  String? desId;
  String? sendBy;

  UidModel({
    this.uid,
    this.desId,
    this.sendBy
  });

  UidModel.fromJson(json){
    uid = json['uid'];
    desId = json['desId'];
    sendBy = json['sendBy'];
  }
}

