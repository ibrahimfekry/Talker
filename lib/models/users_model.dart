class UserModelRegister{
  String? url;
  String? emailAddress;
  String? firstName;
  String? lastName;
  String? password;
  String? ensurePassword;
  String? date;
  String? status;
  String? uid;


  UserModelRegister({
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.password,
    this.ensurePassword,
    this.date,
    this.status,
    this.uid,
    this.url
  });

  UserModelRegister.fromJson(json){
    emailAddress = json["emailAddress"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    password = json["password"];
    ensurePassword = json["ensurePassword"];
    date= json["date"];
    status= json["status"];
    uid= json["uid"];
    url= json["urlImage"];
  }

  Map toMap() {
    return {
      "emailAddress" : emailAddress,
      "firstName" : firstName,
      "lastName" : lastName,
      "password" : password,
      "ensurePassword" : ensurePassword,
      "date" : date,
      "status" : status,
      "uid" : uid,
      "urlImage" : url,
    };
  }

}