import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skincare_app/users/authentication/login_screen.dart';
import 'package:skincare_app/users/userPreferences/current_user.dart';
import 'package:skincare_app/users/userPreferences/user_preferences.dart';

class ProfileFragmentScreen extends StatelessWidget {
  //------- FUNGSI UNTUK MEMANGGIL EMAIL USER YANG SUDAH LOGIN UNTUK TAMPIL KE PROFILE----------------//
  final CurrentUser _currentUser = Get.put(CurrentUser());

  //------- FUNGSI UNTUK SIGN OUT USER --------------------------------------//
  signOutUser() async{
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are You Sure To Logout?",
        ),
        actions: [
          //---------BUTTON LOGOUT--------------------------------------------//
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
          TextButton(
              onPressed: () {
                Get.back(result: "LoggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
    );

    if(resultResponse == "LoggedOut"){
      //----------------- DELETE USER DATA FROM LOCAL STORAGE TO LOGOUT-------//
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(LoginScreen());
      });
    }
  }

  //--------------------- FUNGSI MENAMPILKAN USERNAME & ICON DI PROFILE--------------//
  Widget userInfoItemProfile(IconData iconData, String userData){
    return Container(
      //--------- DECORATION BOX ---------------------------------------------//
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.pinkAccent,
          ),
          const SizedBox(width: 16,),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset(
            "images/man.png",
            width: 200,
          ),
        ),

        const SizedBox(height: 20,),

        userInfoItemProfile(Icons.person, _currentUser.user.user_name),
        const SizedBox(height: 20,),
        userInfoItemProfile(Icons.email, _currentUser.user.user_email),
        const SizedBox(height: 20,),

        Center(
          child: Material(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: (){
                signOutUser();

              },
              borderRadius: BorderRadius.circular(30),
              child: const Padding(
                padding:  EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),




      ],
    );
  }
}
