class User {
  int userID;
  String token,
      name,
      email,
      phoneNumber,
      location,
      password,
      userIDStr,
      address;

  User(
      {this.token,
      this.userID,
      this.name,
      this.email,
      this.phoneNumber,
      this.location,
      this.password,
      this.userIDStr,
      this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userID: json['id'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phonenumber'],
        location: json['location']);
  }
  Map toLogin() {
    var map = new Map<String, dynamic>();
    map["token"] = token;
    map["email"] = email;
    map["password"] = password;

    return map;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = token;
    map["name"] = name;
    map["email"] = email;
    map["password"] = password;
    map["phonenumber"] = phoneNumber;
    map["location"] = location;
    map["address"] = address;

    return map;
  }

  Map toUpdate() {
    var map = new Map<String, dynamic>();
    map["token"] = token;
    map["id"] = userIDStr;
    map["name"] = name;
    map["email"] = email;
    map["password"] = password;
    map["phonenumber"] = phoneNumber;
    map["location"] = location;

    return map;
  }

  Map toForget() {
    var map = new Map<String, dynamic>();
    map["token"] = token;
    map["email"] = email;

    return map;
  }
}
