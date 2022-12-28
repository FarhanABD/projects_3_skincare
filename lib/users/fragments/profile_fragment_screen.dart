import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:skincare_app/users/authentication/login_screen.dart';
import 'package:skincare_app/users/cart/cart_list_screen.dart';
import 'package:skincare_app/users/fragments/about_fragment_screen.dart';
import 'package:skincare_app/users/fragments/dashboard_fragments.dart';
import 'package:skincare_app/users/fragments/favourite_fragment_screen.dart';
import 'package:skincare_app/users/fragments/home_fragment_screen.dart';
import 'package:skincare_app/users/fragments/order_fragment_screen.dart';
import 'package:skincare_app/users/order/history_screen.dart';
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
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: ()
          {
            Get.to(DashboardOfFragments());
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.pinkAccent,
          ),
        ),
        actions: [
          IconButton(
            onPressed: ()
            {
              Get.to(AboutFragmentScreen());
            },
            icon: Icon(
              Icons.info_outline_rounded,
              color: Colors.pinkAccent,
            ),
          ),
          IconButton(
            onPressed: ()
            {
              signOutUser();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Image.asset(
                "images/person_circle_icon_png.png",
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10,
            ),
            userInfoItemProfile(Icons.person, _currentUser.user.user_name),
            const SizedBox(height: 20,),
            userInfoItemProfile(Icons.email, _currentUser.user.user_email),
            const SizedBox(height: 20,),

            const Divider(indent: 10, endIndent: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 100,
                  child: Column(
                    children:  [
                      IconButton(
                        onPressed: (){
                          Get.to(CartListScreen());
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.pinkAccent,
                        ),
                      ),
                       SizedBox(height: 10,),

                       const Text("Cart Page", style: TextStyle(
                          color: Colors.pinkAccent,
                         fontWeight: FontWeight.bold,
                         fontSize: 14,
                       ),

                       ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 100,
                  child: Column(
                    children:  [
                      IconButton(
                        onPressed: (){
                          Get.to(() => HistoryScreen());
                        },
                        icon: const Icon(
                          Icons.history,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 10,),

                      const Text("History", style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),

                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 100,
                  child: Column(
                    children:  [
                      IconButton(
                        onPressed: (){
                          Get.to(OrderFragmentScreen());
                        },
                        icon: const Icon(
                          FontAwesomeIcons.boxOpen,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      SizedBox(height: 10,),

                      const Text("Order Page", style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],),
        ),
      ),
    );
  }
}