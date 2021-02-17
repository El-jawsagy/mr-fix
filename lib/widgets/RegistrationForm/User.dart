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

  User({
    this.token,
    this.userID,
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.password,
    this.userIDStr,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userID: json['id'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phonenumber'],
        location: json['location']);
  }
  Map<String, dynamic> toLogin() {
    return {
      "token": token,
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "token": token,
      "name": name,
      "email": email,
      "password": password,
      "phonenumber": phoneNumber,
      "location": location.toString(),
    };
  }

  Map<String, dynamic> toUpdate() {
    return {
      "token": token,
      "id": userIDStr,
      "name": name,
      "email": email,
      "password": password,
      "phonenumber": token,
      "location": location,
    };
  }

  Map<String, dynamic> toForget() {
    return {
      "token": token,
      "email": email,
    };
  }
}
