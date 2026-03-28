import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_screen.dart';
import 'screens/preview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Website Builder SaaS',
      debugShowCheckedModeBanner: false,

      initialRoute: "/",

      routes: {
        "/": (c) => LoginScreen(),
        "/dashboard": (c) => DashboardScreen(),
        "/create": (c) => CreateScreen(),
        "/preview": (c) => PreviewScreen(),
      },
    );
  }
}