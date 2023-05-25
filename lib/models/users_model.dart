class UserModelRegister{
  String? emailAddress;
  String? firstName;
  String? lastName;
  String? password;
  String? ensurePassword;
  String? date;


  UserModelRegister({
    this.emailAddress,
    this.firstName,
    this.lastName,
    this.password,
    this.ensurePassword,
    this.date,
  });

  UserModelRegister.fromJson(json){
    emailAddress = json["emailAddress"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    password = json["password"];
    ensurePassword = json["ensurePassword"];
    date= json["date"];
  }

  Map toMap() {
    return {
      "emailAddress" : emailAddress,
      "firstName" : firstName,
      "lastName" : lastName,
      "password" : password,
      "ensurePassword" : ensurePassword,
      "date" : date,
    };
  }

}