// ignore_for_file: unused_local_variable, library_private_types_in_public_api, prefer_final_fields, sized_box_for_whitespace, prefer_const_constructors, use_key_in_widget_constructors, unused_import, use_build_context_synchronously, unused_field

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ปิด Debug Banner
      theme: ThemeData(
        primarySwatch: Colors.indigo, // สีหลัก
        hintColor: Colors.lightBlueAccent, // สีรอง
        // สามารถกำหนดค่าอื่น ๆ ใน ThemeData ตามต้องการ
      ),
      home: TableListScreen(),
    );
  }
}

// ignore: must_be_immutable
class TableListScreen extends StatelessWidget {
  List<Map<String, dynamic>> tables = [
    {"number": 1, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 2, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 3, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 4, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 5, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 6, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 7, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 8, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 9, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 10, "type": "Standard", "price": 1500, "status": "available"},
    {"number": 11, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 12, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 13, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 14, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 15, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 16, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 17, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 18, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 19, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 20, "type": "VIP", "price": 5000, "status": "available"},
    {"number": 21, "type": "Family", "price": 2500, "status": "available"},
    {"number": 22, "type": "Family", "price": 2500, "status": "available"},
    {"number": 23, "type": "Family", "price": 2500, "status": "available"},
    {"number": 24, "type": "Family", "price": 2500, "status": "available"},
    {"number": 25, "type": "Family", "price": 2500, "status": "available"},
  ];

  TableListScreen();
 Color _getTableColor(String status) {
    if (status == 'available') {
      return Color.fromARGB(173, 97, 168, 234);
    } else if (status == 'paid') {
      return Colors.pink;
    } else if (status == 'dont') {
      return Colors.red;
    } else if (status == 'reserved') {
      // Add this block for reserved status
      return Colors
          .blue; // Change this color to the one you prefer for reserved tables
    } else {
      return Colors.orangeAccent;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("จองโต๊ะ")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, //คอลัมน์โต๊ะ
          ),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (tables[index]['status'].toLowerCase() != 'reserved' &&
                    tables[index]['status'].toLowerCase() != 'dont') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TableBookingScreen(tableData: tables[index]),
                    ),
                  );
                } else {
                  // // แสดงข้อความหรือดิอาล็อกที่ระบุว่าโต๊ะนี้มีสถานะเป็น "reserved" หรือ "dont" และไม่สามารถจองได้
                  String message = tables[index]['status'].toLowerCase() == 'reserved'
                      ? 'โต๊ะ ${tables[index]['number']} มีการจองแล้ว'
                      : 'โต๊ะ ${tables[index]['number']} ไม่สามารถจองได้';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          message),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Card(
                color: _getTableColor(tables[index]['status']),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_chart),
                      Text("โต๊ะ ${tables[index]['number']}"),
                      Text(
                          "${tables[index]['type']} - ฿${tables[index]['price']}"),
                      if (tables[index]['status'] == 'reserved')
                        FutureBuilder<String?>(
                          future: fetchReservedBy(
                              int.parse(tables[index]['number'].toString())),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text("ข้อผิดพลาด: ${snapshot.error}");
                            } else if (snapshot.hasData) {
                              return Text("จองโดย: ${snapshot.data}");
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
  
  Future<String?> fetchReservedBy(int tableNumber) async {
    const apiUrl = 'http://localhost:3000/api/authmanagement'; // เปลี่ยนเป็น URL ของ API ที่ให้บริการการดึงข้อมูลชื่อผู้จอง

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tableNumber': tableNumber,
          'includebookedby': true, // เพิ่มบรรทัดนี้
        }),
      );

       if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Received bookedby from API: ${data['bookedby']}');
        return data['bookedby'];
      } else {
        throw Exception('Failed to fetch bookedby');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

}

class TableBookingScreen extends StatefulWidget {
  final Map<String, dynamic> tableData;
  final String? bookedby;

  const TableBookingScreen({required this.tableData , this.bookedby});
  

  @override
  _TableBookingScreenState createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends State<TableBookingScreen> {
  void _showReceiptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Receipt"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReceipt(), // เพิ่ม Widget ที่แสดงข้อมูลใบเสร็จ
                SizedBox(height: 16),
                _buildPrintButton(), // เพิ่มปุ่ม Print
              //   Text("Reservation details:"),
              //   Text("Table number: ${widget.tableData['number']}"),
              //   Text("Type: ${widget.tableData['type']}"),
              //   Text("Price: \$${widget.tableData['price']}"),
              //   SizedBox(height: 16),
              //   Text("Customer information:"),
              //   Text("Name: ${_nameController.text}"),
              //   Text("Date: ${DateFormat.yMd().format(_selectedDateTime)}"),
              //   Text("Time: ${_selectedTime.format(context)}"),
              //   SizedBox(height: 16),
              //   Text("Payment status: $_paymentStatus"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
  late TextEditingController _nameController;
  late DateTime _selectedDateTime;
  late TimeOfDay _selectedTime;
  String _paymentStatus = "Pending";
  String _status = "reserved";

   // สร้างตัวแปรเพื่อเก็บสถานะเดิมของโต๊ะ
  late String _originalStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(); // เพิ่มบรรทัดนี้
    _selectedDateTime = DateTime.now();
    _selectedTime = TimeOfDay.now();


      // เก็บสถานะเดิมของโต๊ะ
    _originalStatus = widget.tableData['status'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }


  Future<void> _selectDateTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

//ส่วนการส่งข้อมูลที่จะบันทึกไปยังตัวของหน้า api
 Future<void> saveData(BuildContext context) async {
    const apiUrl = 'http://localhost:3000/api/auth/management';

    // Extract data from the form
    String bookedby = _nameController.text;
    String typeTable = widget.tableData['type'];
    int tableNumber = widget.tableData['number'];
    double price =widget.tableData['price'].toDouble(); // Convert price to double

    // Format date and time
    DateTime selectedDateTimeWithTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Convert date and time to string for API
    String formattedDateTime = selectedDateTimeWithTime.toIso8601String();

      try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reserve': true,
          'bookedby': bookedby,
          'typeTable': typeTable,
          'price': price,
          'datetime': formattedDateTime,
          'status': (_paymentStatus == "ชำระแล้ว") ? 'paid' : 'dont',
          'tableNumber': tableNumber.toString(), // ใช้ tableNumber ที่ถูกเลือก
        }),
      );

      if (response.statusCode == 200) {
        
        // Successful response
        if (kDebugMode) {
          print('Data saved successfully');
          
        }

          // เพิ่มตรวจสอบสถานะเดิมของโต๊ะ
if (_originalStatus.toLowerCase() != 'dont') {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'reserve': true,
      'bookedby': bookedby,
      'typeTable': typeTable,
      'price': price,
      'datetime': formattedDateTime,
      'status': (_paymentStatus == "ชำระแล้ว") ? 'paid' : 'dont',
      'tableNumber': tableNumber.toString(),
    }),
  );
  } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('โต๊ะ ${widget.tableData['number']} ไม่สามารถจองได้'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reservation saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

      // Update table status in the TableListScreen
        setState(() {
          widget.tableData['status'] = 'reserved';
        });
        
        // Clear form data
        _nameController.clear();
      } else {
        // Unsuccessful response
        if (kDebugMode) {
          print('Failed to save data. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('An error occurred: $e');
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      }

      
  }

  // เพิ่ม Widget สำหรับแสดงข้อมูลใบเสร็จ
  Widget _buildReceipt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reservation details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Table number: ${widget.tableData['number']}"),
        Text("Type: ${widget.tableData['type']}"),
        Text("Price: \$${widget.tableData['price']}"),
        SizedBox(height: 16),
        Text("Customer information:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Name: ${_nameController.text}"),
        Text("Date: ${DateFormat.yMd().format(_selectedDateTime)}"),
        Text("Time: ${_selectedTime.format(context)}"),
        SizedBox(height: 16),
        Text("Payment status: $_paymentStatus",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

   // เพิ่มปุ่ม "Print"
  Widget _buildPrintButton() {
    return ElevatedButton(
      onPressed: () {
        // Add logic for printing the receipt
       _showReceiptDialog();
      },
      child: Text("Print"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Table ${widget.tableData['number']} Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                " tableNumber: ${widget.tableData['number']}",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Type: ${widget.tableData['type']}",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Price: \$${widget.tableData['price']}",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: 100.0,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0)),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Date: ${DateFormat.yMd().format(_selectedDateTime)}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
                Text("Time: ${_selectedTime.format(context)}"),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectDateTime(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _paymentStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _paymentStatus = newValue!;
                });
              },
              items: ["Pending", "ชำระแล้ว", "ค้างชำระ"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () => saveData(context),
              child: Text("Save"),
            ),
            SizedBox(height: 16.0),
            _buildPrintButton(), // เพิ่มปุ่ม "Print"
          ],
        ),
      ),
    );
  }
}