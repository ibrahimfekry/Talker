class GroupModel {
  String? groupName;
  String? id;

  GroupModel({
    this.groupName,
    this.id
  });

  GroupModel.fromJson(json){
    groupName = json['name'];
    id = json['id'];
  }
}