
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skincare_app/users/model/user.dart';

class RememberUserPrefs{
  // SAVE USER INFO
  static Future<void> storeUserInfo(User userinfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userinfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  // get-read user-info
  static Future<User?> readUserInfo() async{
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userinfo = preferences.getString("currentUser");
    if(userinfo != null)
    {
      Map<String, dynamic> userDataMap = jsonDecode(userinfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;

  }
}