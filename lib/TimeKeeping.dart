import 'package:appcheckin/dateTimeKeeping.dart';
import 'package:appcheckin/monthTimeKeeping.dart';
import 'package:flutter/material.dart';

class TimeKeeping extends StatefulWidget {
  const TimeKeeping({super.key});

  @override
  State<TimeKeeping> createState() => _TimeKeepingState();
}

class _TimeKeepingState extends State<TimeKeeping> {
  bool showNgayScreen = true; // Mặc định hiển thị màn hình ngày

  void toggleScreen() {
    setState(() {
      showNgayScreen = !showNgayScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('NGÀY CÔNG', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: toggleScreen,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: showNgayScreen
                                ? Color.fromARGB(255, 183, 186, 187)
                                : Colors
                                    .white, // Thay đổi màu sắc của ngày khi được chọn hoặc tháng được chọn
                            child: Center(
                              child: Text(
                                'NGÀY',
                                style: TextStyle(
                                    color: showNgayScreen
                                        ? Colors.white
                                        : Colors
                                            .black), // Thay đổi màu sắc của văn bản tùy thuộc vào trạng thái
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: toggleScreen,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: showNgayScreen
                                ? Colors.white
                                : Color.fromARGB(255, 183, 186,
                                    187), // Thay đổi màu sắc của tháng khi được chọn hoặc ngày được chọn
                            child: Center(
                              child: Text(
                                'THÁNG',
                                style: TextStyle(
                                    color: showNgayScreen
                                        ? Colors.black
                                        : Colors
                                            .white), // Thay đổi màu sắc của văn bản tùy thuộc vào trạng thái
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showNgayScreen) ...[DateTimeKeeping()],
                  if (!showNgayScreen) ...[MonthTimeKeeping()],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
