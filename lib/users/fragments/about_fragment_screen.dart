import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

// void main() => runApp(AboutFragmentScreen());

class AboutFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: ContactUsBottomAppBar(
          companyName: 'Etalase Talisya',
          textColor: Colors.white,
          backgroundColor: Colors.pinkAccent,
          email: 'najwa.am2003@gmail.com',
          // textFont: 'Sail',
        ),

        backgroundColor: Colors.white,
        body: ContactUs(
            cardColor: Colors.white70,
            textColor: Colors.pink,
            logo: AssetImage('images/logo_baru.png'),
            email: 'najwa.am2003@gmail.com',
            companyName: 'Etalase Talisya',
            companyColor: Colors.pinkAccent,
            dividerThickness: 2,
            phoneNumber: '+62 81353401336',
            tagLine: 'About Us',
            taglineColor: Colors.pinkAccent.shade100,
            instagram: 'etalasetalisya.new',
        ),
      ),
    );
  }
}