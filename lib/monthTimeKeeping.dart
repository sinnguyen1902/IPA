import 'dart:convert';

import 'package:appcheckin/detailChenkin.dart';
import 'package:appcheckin/notify.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MonthTimeKeeping extends StatefulWidget {
  MonthTimeKeeping({super.key});

  @override
  State<MonthTimeKeeping> createState() => _MonthTimeKeepingState();
}

class _MonthTimeKeepingState extends State<MonthTimeKeeping> {
  List<TableRow> tableRows = [];
  late DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    monthTimeKeepingProcess(); // Gọi phương thức để lấy dữ liệu khi StatefulWidget được khởi tạo
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
        monthTimeKeepingProcess();
      });
  }

  Future<void> monthTimeKeepingProcess() async {
    String? userID = UserData.iEmpNo.toString();
    String? monthTime = _selectedDate.month.toString();
    String? yearTime = _selectedDate.year.toString();
    String url =
        'http://115.75.88.138:8668/APP-CHECKIN/public/api/CheckedMonth/$userID/$monthTime/$yearTime';
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
                      entry['ID_DATE'].toString(),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      entry['COUNT'].toString(),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        if (entry['COUNT'] > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(100, 10),
                              foregroundColor: const Color(0xFFfef141),
                              backgroundColor:
                                  Colors.red, // Text Color (Foreground color)
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailCheckin(
                                        date: entry['DATE'].toString())),
                              );
                            },
                            child: const Text(
                              'Chi Tiết',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        if (entry['COUNT'] <= 0) Text('Không có dữ liệu!'),
                      ],
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
                'THÁNG : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
                    child: Text('Ngày'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Số lần'),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text('Hành Động'),
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
