import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
    
    void showToast(String data) {
      Fluttertoast.showToast(
          msg: data,
          toastLength:
              Toast.LENGTH_LONG, // Đặt thời gian hiển thị khoảng 3 giây
          gravity:
              ToastGravity.BOTTOM, // Hiển thị ở vị trí dưới cùng của màn hình
          timeInSecForIosWeb: 3, // Đặt thời gian hiển thị cho iOS
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0);
    }