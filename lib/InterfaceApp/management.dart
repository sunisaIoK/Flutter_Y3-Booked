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
        primarySwatch: Colors.pink,
        hintColor: Colors.lightGreen,
      ),
      home: MyHomePage1(),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การจัดการข้อมูล'),
      ),
      body: Container(
        color: Color.fromARGB(
            153, 225, 203, 225), // Set the desired background color
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    color: Color.fromARGB(
                        235, 208, 172, 197), // เพิ่มบรรทัดนี้เพื่อเปลี่ยนสีม่วง
                    margin: EdgeInsets.all(20.0),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Color.fromARGB(255, 24, 136, 222),
                            onPressed: () {
                              navigateToEditScreen(item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Color.fromARGB(255, 182, 55, 17),
                            onPressed: () {
                              // เพิ่มโค้ดสำหรับลบข้อมูล
                              showDeleteConfirmationDialog(item['id']!);
                            },
                          ),
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

  // เพิ่มฟังก์ชันแสดงตัวยืนยันการลบ
  Future<void> showDeleteConfirmationDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบข้อมูล'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณแน่ใจหรือไม่ที่ต้องการลบข้อมูลนี้?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ลบ'),
              onPressed: () async {
                // เรียกใช้ฟังก์ชัน deleteData เพื่อลบข้อมูล
                await (String id) async {
                  try {
                    final response = await http.delete(
                      Uri.parse('http://localhost/manage.php?id=$id'),
                      body: jsonEncode({'id': id}),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200) {
                      // Data deletion successful
                      print('Data deleted successfully');

                      // เรียกใช้ฟังก์ชัน fetchData หลังจากลบข้อมูลเสร็จ
                      await fetchData();
                    } else {
                      print(
                          'Failed to delete data. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error deleting data: $e');
                  }
                }(id);
                Navigator.of(context)
                    .pop(); // ปิดกล่องโต้ตอบหลังจากที่ลบข้อมูลเสร็จสิ้น
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> data = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> deleteData(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost/manage.php?id=$id'),
        body: jsonEncode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Data deletion successful
        print('Data deleted successfully');
      } else {
        print('Failed to delete data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting data: $e');
    }
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

  // เพิ่มฟังก์ชันลบข้อมูล

  void navigateToEditScreen(Map<String, String> item) {
    final editUrl = 'http://localhost/manage.php?id=${item['id']}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(url: editUrl, item: item),
      ),
    ).then((value) {
      if (value != null && value) {
        // ถ้าการลบหรือแก้ไขสำเร็จ ให้ดึงข้อมูลใหม่
        fetchData();
      }
    });
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

  // ฟังก์ชันสำหรับบันทึกการแก้ไข
  Future<void> saveChanges() async {
    try {
      final response = await http.put(
        Uri.parse(widget.url),
        headers: {
          'Content-Type':
              'application/json', // เพิ่ม header สำหรับระบุว่าส่งข้อมูลเป็น JSON
        },
        body: jsonEncode({
          'id': widget.item['id']!,
          'datetime': datetimeController.text,
          'tableNumber': tableNumberController.text,
          'bookedby': bookedbyController.text,
          'typeTable': typetableController.text,
          'price': priceController.text,
          'status': statusController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // ส่งค่า true กลับไปยังหน้าที่เรียก
      } else {
        print('Failed to save changes. Status code: ${response.statusCode}');
        Navigator.pop(context, false); // ส่งค่า false กลับไปยังหน้าที่เรียก
      }
    } catch (e) {
      print('Error saving changes: $e');
      Navigator.pop(context, false); // ส่งค่า false กลับไปยังหน้าที่เรียก
    }
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Call your function
                await saveChanges();
              },
              child: Container(
                height: 40, // Set the height to 40 pixels (adjust as needed)
                width: double
                    .infinity, // Set the width to fill the available space
                child: Center(
                  child: Text(
                    'บันทึกการแก้ไข',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 146, 97, 179),
                // Button color
              ),
            )
          ],
        ),
      ),
    );
  }
}
