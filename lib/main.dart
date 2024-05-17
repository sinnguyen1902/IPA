// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:appcheckin/home.dart';
import 'package:appcheckin/notify.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // Getting the full screen height
    double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController password = TextEditingController();
    final TextEditingController userID = TextEditingController();
    String? deviceID;

    Future<String> getDeviceId() async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceID = androidInfo.androidId;
        getDevice.idDevice = deviceID!;
        return androidInfo.androidId.toString();
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceID = iosInfo.identifierForVendor;
        getDevice.idDevice = deviceID!;
        return iosInfo.identifierForVendor.toString();
      }
      return "Unknown Device";
    }

    Future<void> loginProcess() async {
      const String url =
          'http://115.75.88.138:8668/APP-CHECKIN/public/api/Login';
      String? idUser = userID.text;
      String? PASS = password.text;
      String? MAC = deviceID.toString();
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'ID_USER': idUser,
            'PASS': PASS,
            'MAC': MAC,
          }),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          if (data.containsKey('False')) {
            String errorMessage = data['False'];
            showToast(errorMessage);
          } else {
            showToast('Đăng nhập thành công!');
            UserData.iEmpNo = data['i_emp_no'];
            UserData.nName = data['n_name'];
            UserData.nDept = data['n_dept'];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }
        } else {
          showToast('Lỗi: ${response.body}');
        }
      } catch (e) {
        showToast('Lỗi: $e');
      }
    }

    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // Set the container's height to be full screen height
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
                const Image(
                  image: AssetImage('assets/images/Logo.png'),
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: userID,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      iconColor: Color(0xFFfef141),
                      hintText: 'DP01234 ...',
                      labelText: 'ID Nhân Viên',
                      labelStyle: TextStyle(
                        color: Color(0xFFfef141),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFfef141), width: 2.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.security),
                      iconColor: Color(0xFFfef141),
                      labelStyle: TextStyle(
                        color: Color(0xFFfef141),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: '********',
                      labelText: 'Mật Khẩu',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFfef141), width: 2.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<String>(
                    future: getDeviceId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Lỗi: ${snapshot.error}");
                        }
                        return Text(
                          '${snapshot.data}',
                          style: const TextStyle(
                            color: Color(0xFFfef141),
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFfef141),
                            decorationThickness: 1,
                          ),
                        );
                      } else {
                        // Show a loading spinner while waiting for the Future to complete
                        return const CircularProgressIndicator();
                      }
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFfef141),
                    backgroundColor:
                        Colors.red, // Text Color (Foreground color)
                  ),
                  onPressed: () {
                    loginProcess();
                    // showToast();
                  },
                  child: const Text('Đăng Nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
