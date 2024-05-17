import 'package:appcheckin/Checkin.dart';
import 'package:appcheckin/TimeKeeping.dart';
import 'package:appcheckin/changepassword.dart';
import 'package:appcheckin/main.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    UserData.iEmpNo = '';
    UserData.nName = '';
    UserData.nDept = '';
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Image(
                image: AssetImage('assets/images/Logo.png'),
                height: 40,
                width: 40,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'NEXTGO',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        body: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.red],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                title: "Ngày Công",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TimeKeeping()),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Button(
                title: "Chấm Công",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Checkin()),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Button(
                title: "Đổi Mật Khẩu",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Button(
                title: "Đăng Xuất",
                onPressed: () {
                  logout();
                },
              ),
            ],
          ),
        ));
  }
}

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const Button({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 45,
          width: 350,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFfef141), // Màu nền của nút
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5), // Định dạng hình dạng của nút
              ),
            ),
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red), // Kích thước và màu chữ của nút
            ),
          ),
        ),
      ],
    );
  }
}
