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

  ///警告类
  static warn(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color.fromARGB(255, 162, 153, 20));
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
