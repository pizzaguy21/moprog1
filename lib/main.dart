import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/verification_screen.dart'; 
import 'screens/resetpw_screen.dart';
import 'screens/favourites_screen.dart'; // Import layar Favorites
import 'screens/personal_screen.dart';
import 'screens/accsecurity_screen.dart';
import 'screens/about_screen.dart';
import 'screens/appset_screen.dart';



void main() {
  runApp(const PolylingoApp());
}

class PolylingoApp extends StatelessWidget {
  const PolylingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polylingo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B61DD),
        scaffoldBackgroundColor: const Color(0xFF4B61DD),
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/resetpw': (context) => const ResetPwScreen(),
        '/favourites': (context) => const FavouritesScreen(),
        '/personal': (context) => const PersonalScreen(),
        '/accountSecurities': (context) => AccountSecuritiesScreen(),
        '/about': (context) => AboutScreen(),
        '/appSettings': (context) => const AppSetScreen(), 

      },
    );
  }
}
