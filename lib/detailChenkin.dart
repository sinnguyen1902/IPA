import 'dart:convert';

import 'package:appcheckin/notify.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailCheckin extends StatefulWidget {
  final String date;

  // Constructor với tham số 'date'
  DetailCheckin({required this.date});

  // Khởi tạo một instance của _DetailCheckinState
  @override
  _DetailCheckinState createState() => _DetailCheckinState();
}

class _DetailCheckinState extends State<DetailCheckin> {
  List<TableRow> tableRows = [];

  @override
  void initState() {
    super.initState();
    dateTimeKeepingProcess(); // Gọi phương thức để lấy dữ liệu khi StatefulWidget được khởi tạo
  }

  Future<void> dateTimeKeepingProcess() async {
    String? userID = UserData.iEmpNo.toString();
    String? dateTime = widget.date;
    String url =
        'http://115.75.88.138:8668/APP-CHECKIN/public/api/Checked/$userID/$dateTime';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<TableRow> rows = [];
        for (var entry in data) {
          rows.add(
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      entry['kh_name'] ?? '',
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      entry['address'] ?? '',
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image.network(
                      'http://115.75.88.138:8668/JHSIOT/data/imgthitruong/${entry['url_img']}',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      entry['sys_date'] ?? '',
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        setState(() {
          tableRows = rows;
        });
      } else {
        showToast('Lỗi: ${response.body}');
      }
    } catch (e) {
      showToast('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('CHI TIẾT NGÀY CÔNG',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  TableCell(
                    child: Center(
                      child: Text('KH'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Địa Điểm'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Hình ảnh'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Thời Gian'),
                    ),
                  ),
                ]),
                ...tableRows
              ],
            ),
          ),
        ),
      ),
    );
  }
}
