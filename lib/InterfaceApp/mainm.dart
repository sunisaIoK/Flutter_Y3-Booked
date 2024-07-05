import 'package:flutter/material.dart';
import 'index.dart';
import 'management.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Reservation System',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage5(),
      debugShowCheckedModeBanner:
          false, // Set this to false to remove the debug banner
    );
  }
}
// HomePage, ใช้ GridView.builder เพื่อสร้างตารางแสดงข้อมูล.
// GridItem คือ Widget ที่ใช้แสดงข้อมูลแต่ละรายการในตาราง.

class HomePage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบจองโต๊ะ'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text(
                ' ระบบจองโต๊ะ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage3()),);
              },
            ),
            ListTile(
              title: Text('Reservation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TableListScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage1()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: const Center(
        child: Text(
          'Reservation Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: const Center(
        child: Text(
          'Receipt Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Management'),
      ),
      body: Center(
        child: Text(
          'Management Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
