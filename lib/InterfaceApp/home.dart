import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        hintColor: Colors.lightBlueAccent,
      ),
      home: MyHomePage3(),
    );
  }
}

class MyHomePage3 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage3> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการจอง'),
      ),
      body: Container(
        color: Color.fromARGB(
            235, 255, 205, 25), // Set the desired background color
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    color: Color.fromARGB(
                        235, 255, 255, 255), // เพิ่มบรรทัดนี้เพื่อเปลี่ยนสีม่วง
                    margin: EdgeInsets.all(100.0),
                    child: ListTile(
                      title: Text('เวลา: ${item['datetime']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('โต๊ะที่: ${item['tableNumber']}'),
                          Text('จองโดย: ${item['bookedby']}'),
                          Text('ประเภทโต๊ะ: ${item['typeTable']}'),
                          Text('สถานะการจอง: ${item['status']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> data = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/manage.php'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        setState(() {
          data = dataList.map((data) {
            return {
              'id': data['id'].toString(),
              'tableNumber': data['tableNumber'].toString(),
              'datetime': data['datetime'].toString(),
              'bookedby': data['bookedby'].toString(),
              'typeTable': data['typeTable'].toString(),
              'price': data['price'].toString(), // เพิ่ม 'price'
              'status': data['status'].toString(),
            };
          }).toList();
        });
      } else {
        print('ไม่สามารถโหลดข้อมูลได้ รหัสสถานะ: ${response.statusCode}');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }
}

class EditScreen extends StatefulWidget {
  final String url;
  final Map<String, String> item;

  EditScreen({required this.url, required this.item});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController datetimeController = TextEditingController();
  TextEditingController bookedbyController = TextEditingController();
  TextEditingController typetableController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController tableNumberController = TextEditingController();
  TextEditingController priceController =
      TextEditingController(); // เพิ่ม controller

  @override
  void initState() {
    datetimeController.text = widget.item['datetime']!;
    tableNumberController.text = widget.item['tableNumber']!;
    bookedbyController.text = widget.item['bookedby']!;
    typetableController.text = widget.item['typeTable']!;
    statusController.text = widget.item['status']!;
    priceController.text =
        widget.item['price']!; // เพิ่มค่าเริ่มต้นสำหรับราคาโต๊ะ
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูล'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(110.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ID: ${widget.item['id']}'),
            SizedBox(height: 16.0),
            TextField(
              controller: datetimeController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'เวลา'),
            ),
            SizedBox(height: 16.0),
            Text(
              'เลขโต๊ะ: ${widget.item['tableNumber']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: bookedbyController,
              decoration: InputDecoration(labelText: 'จองโดย'),
            ),
            SizedBox(height: 16.0),
            Text(
              'ประเภทโต๊ะ: ${widget.item['typeTable']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'ราคา: ${widget.item['price']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'สถานะการจอง'),
            ),
          ],
        ),
      ),
    );
  }
}
