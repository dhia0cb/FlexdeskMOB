import 'package:flutter/material.dart';
import 'package:front_mobile/auth/user.dart';
import 'package:front_mobile/models/space_provider.dart';
import 'screens/bottom_navigation.dart';
import 'screens/login_screen.dart'; 

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SpaceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Office Booking',
      theme: ThemeData(primarySwatch: Colors.blue),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const BottomNavigation(),
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
