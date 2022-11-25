import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/users/fragments/dashboard_fragments.dart';
import 'package:skincare_app/users/model/user.dart';
import 'package:skincare_app/users/userPreferences/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginusernow() async{
    try {
      var res = await http.post
        (
        Uri.parse(Api.login),
        body: {
          'user_email': emailController.text.trim(),
          'user_password':passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200) //Connection with API to server is succes
          {
        var resbodyoflogin = jsonDecode(res.body);
        if(resbodyoflogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "Login Succesfully :)");

          User userinfo = User.fromJson( resbodyoflogin[ "userData"]);

          //save userInfo to local storage pake Shared Preferences
          await RememberUserPrefs.storeUserInfo(userinfo);

          // Fungsi pindah Activity dari Login ke Dashboard
          Future.delayed(Duration(milliseconds: 2000),(){
            Get.to(DashboardOfFragments());
          });
        }
        else {
          Fluttertoast.showToast(msg: "Email Or Password Is Wrong");
        }

      }
    }
    catch(errorMsg){
      print("Error :: " + errorMsg.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, cons){
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Login Screen Header

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset(
                        "images/logo_baru.png",

                      ),
                    ),
                  ),

                  //Login Screen Sign-in Form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [

                            // email-password-login btn
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  //Email Textfield
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) => val == "" ? "Please Insert The Email" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black26,
                                      ),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(height: 18,),

                                  //Password Textfield
                                 Obx(
                                     ()=>  TextFormField(
                                       controller: passwordController,
                                       obscureText: isObsecure.value,
                                       validator: (val) => val == "" ? "Please Insert The password" : null,
                                       decoration: InputDecoration(
                                         prefixIcon: const Icon(
                                           Icons.vpn_key_sharp,
                                           color: Colors.black26,
                                         ),

                                         //Untuk Melihat Password
                                         suffixIcon: Obx(
                                               ()=> GestureDetector(
                                             onTap: (){
                                               isObsecure.value = !isObsecure.value;

                                             },
                                             child: Icon(
                                               isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                               color: Colors.pinkAccent,
                                             ),
                                           ),
                                         ),
                                         hintText: "password...",
                                         border: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(
                                             color: Colors.white60,
                                           ),
                                         ),
                                         enabledBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(
                                             color: Colors.white60,
                                           ),
                                         ),
                                         focusedBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(
                                             color: Colors.white60,
                                           ),
                                         ),
                                         disabledBorder: OutlineInputBorder(
                                           borderRadius: BorderRadius.circular(30),
                                           borderSide: const BorderSide(
                                             color: Colors.white60,
                                           ),
                                         ),
                                         contentPadding: const EdgeInsets.symmetric(
                                           horizontal: 14,
                                           vertical: 6,
                                         ),
                                         fillColor: Colors.white,
                                         filled: true,
                                       ),
                                     ),
                                 ),

                                  const SizedBox(height: 18,),


                                  // Button Login
                                  Material(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if (formKey.currentState!.validate())
                                        {
                                          loginusernow();
                                        }

                                      },
                                      borderRadius: BorderRadius.circular(30) ,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //dont have an account btn - register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Dont have an Account ?"
                                ),
                                TextButton(
                                  onPressed: (){
                                    Get.to(SignUpScreen());

                                  },
                                  child: const Text(
                                    "Register Here",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Text(
                              "Or",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),

                            // Admin Login Btn
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Are You an Admin ?"
                                ),
                                TextButton(
                                  onPressed: (){

                                  },
                                  child: const Text(
                                    "Click Here",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
