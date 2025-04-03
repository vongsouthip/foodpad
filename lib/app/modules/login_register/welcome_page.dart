import 'package:flutter/material.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/login_register/login_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.mainColor,
        image: DecorationImage(
          image: AssetImage('assets/images/welcome.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 200),
              Text(
                textAlign: TextAlign.center,
                'Food\nBloggers',
                style: TextStyle(
                  fontFamily: GoogleFonts.dmSans().fontFamily,
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 60, left: 30, right: 30),
          child: ElevatedButton(
            onPressed: () {
              Get.to(
                () => LoginScreen(),
                transition: Transition.rightToLeft,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.white,
              foregroundColor: CustomColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.dmSans().fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// transitionsBuilder: (
//                           context,
//                           animation,
//                           secondaryAnimation,
//                           child,
//                         ) {
//                           return FadeTransition(
//                             opacity: animation,
//                             child: child,
//                           );
//                         },