import 'dart:convert';

import 'package:appcheckin/notify.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DateTimeKeeping extends StatefulWidget {
  DateTimeKeeping({super.key});

  @override
  State<DateTimeKeeping> createState() => _DateTimeKeepingState();
}

class _DateTimeKeepingState extends State<DateTimeKeeping> {
  List<TableRow> tableRows = [];
  late DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    dateTimeKeepingProcess();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        dateTimeKeepingProcess();
      });
  }

  Future<void> dateTimeKeepingProcess() async {
    String? userID = UserData.iEmpNo.toString();
    String formattedDate = _selectedDate.toString().substring(0, 10);
    String url =
        'http://115.75.88.138:8668/APP-CHECKIN/public/api/Checked/$userID/$formattedDate';
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
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'NGÀY : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.alarm_rounded),
              ),
            ],
          ),
          Table(
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
        ],
      ),
    );
  }
}
