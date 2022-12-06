import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skincare_app/api_connection/api_connection.dart';
import 'package:skincare_app/users/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skincare_app/users/model/user.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();


}

class _SignUpScreenState extends State<SignUpScreen> {



  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async
  {
    try{
      var res = await http.post(
        Uri.parse(Api.validateEmail),
        body: {
          'user_email': emailController.text.trim(),
        },
      );

      if(res.statusCode == 200)  //Connection with API to server is succes
      {
        var resbodyofvalidateEmail = jsonDecode(res.body);
        // var resbodyofvalidateEmail = await json.decode(json.encode(res.body));

        if(resbodyofvalidateEmail['emailFound'] == true)
        {
          Fluttertoast.showToast(msg: "Email Is Already Exist :(");

        }
        else{
          // Register & save new user record to database
          RegisterAndsaveUserRecord();


        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

    }

  }
  RegisterAndsaveUserRecord() async{
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try{
      var res = await http.post
        (
        Uri.parse(Api.signup),
        body: userModel.toJson(),
      );
      if(res.statusCode == 200){
        // var resbodyofSignUp = await jsonDecode(jsonEncode(res.body));
        var resbodyofSignUp = jsonDecode(res.body);
        if(resbodyofSignUp['success'] == true)
        {
          Fluttertoast.showToast(msg: "SignUp Succesfully :)");

          setState(() {

            nameController.clear();
            emailController.clear();
            passwordController.clear();

          });
          Get.to(LoginScreen());
        }
        else{
          Fluttertoast.showToast(msg: "SignUp Unsuccesfull :(");
        }
      }
    }

    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

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


                  // Sign Up Header
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset(
                        "images/logo_baru.png",
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

                                  //Name
                                  TextFormField(
                                    controller: nameController,
                                    validator: (val) => val == "" ? "Please Insert The Name" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black26,
                                      ),
                                      hintText: "name...",
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


                                  // Button SignUp
                                  Material(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formKey.currentState!.validate())
                                        {
                                          //validate User Email
                                          validateUserEmail();
                                        }

                                      },
                                      borderRadius: BorderRadius.circular(30) ,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          "Sign Up",
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

                            const SizedBox(height: 16,),

                            //Already Have account btn - register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Already have an Account ?"
                                ),
                                TextButton(
                                  onPressed: (){
                                    Get.to(LoginScreen());

                                  },
                                  child: const Text(
                                    "Sign In Here",
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
