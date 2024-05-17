import 'dart:convert';
import 'package:appcheckin/notify.dart';
import 'package:flutter/material.dart';
import 'package:appcheckin/userIDLogin.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordOld = TextEditingController();
    final TextEditingController passwordNew = TextEditingController();
    final TextEditingController rePasswordNew = TextEditingController();
    Future<void> changePasswordProcess() async {
      const String url =
          'http://115.75.88.138:8668/APP-CHECKIN/public/api/Change-Password';
      try {
        String? userID = UserData.iEmpNo.toString();
        String? passOld = passwordOld.text;
        String? passNew = passwordNew.text;
        String? passReNew = rePasswordNew.text;
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'I_EMP_NO': userID,
            'I_PASSWORD': passOld,
            'I_PASSWORD_NEW': passNew,
            'I_PASSWORD_RE_NEW': passReNew,
          }),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data.containsKey('False')) {
            String errorMessage = data['False'];
            showToast(errorMessage);
          } else {
            String errorMessage = data['True'];
            showToast(errorMessage);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title:
              const Text('ĐỔI MẬT KHẨU', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
        body: SafeArea(
          child: Container(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: passwordOld,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '******',
                      labelText: 'Nhập mật khẩu cũ',
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: passwordNew,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '*******',
                      labelText: 'Nhập mật khẩu mới',
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    controller: rePasswordNew,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '*******',
                      labelText: 'Nhập lại mật khẩu mới',
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
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFfef141),
                    backgroundColor: Colors.red, // Text Color (Foreground color)
                  ),
                  onPressed: () {
                    changePasswordProcess();
                  },
                  child: const Text('Lưu Mật Khẩu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
