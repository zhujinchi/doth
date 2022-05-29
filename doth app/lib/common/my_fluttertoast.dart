import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/system_info.dart';

///自定义toast弹窗
class MyToast {
  ///通知类
  static info(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: SystemInfo.shared().themeColor,
    );
  }

  ///公告类
  static notice(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 177, 39, 34));
  }

  //通知类
  static show(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromARGB(255, 93, 84, 84));
  }

  ///错误类
  static error(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 177, 39, 34));
  }
}
