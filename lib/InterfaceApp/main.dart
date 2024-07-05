import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
    runApp(MyApp());
  }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
      // Set this to false to remove the debug banner
    );
  }
}
