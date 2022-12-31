// import 'dart:convert';
class Admin{
  int id;
  String name;
  String username;
  String email;
  String password;


  Admin(
      this.id,
      this.name,
      this.username,
      this.email,
      this.password,
      );

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    int.parse(json["id"]),
    json["name"],
    json["username"],
    json["email"],
    json["password"],
  );

  Map<String, dynamic>toJson() => {
    'user_id':id.toString(),
    'name':name,
    'username':username,
    'email':email,
    'password':password,
  };
}
