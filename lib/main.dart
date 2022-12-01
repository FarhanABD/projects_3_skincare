import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:skincare_app/splash_screen.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:skincare_app/users/fragments/dashboard_fragments.dart';
import 'package:skincare_app/users/userPreferences/user_preferences.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Etalase Talisya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapShot)
        {
          if(dataSnapShot.data == null)
          {
            return SplashScreenPage();
          }
          else
          {
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}




