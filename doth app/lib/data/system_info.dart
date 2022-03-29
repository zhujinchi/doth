import 'dart:ffi';

import 'package:doth/common/color_hex.dart';
import 'package:flutter/material.dart';

class SystemInfo {
  SystemInfo._privateConstructor();

  static final SystemInfo _instance = SystemInfo._privateConstructor();

  static SystemInfo shared() {
    return _instance;
  }

  //系统信息
  late Double statusBarHeight;
  late Double bottomBarHeight;
  Color themeColor = HexColor.fromHex('2927a4');
  Color subthemeColor = HexColor.fromHex('bec4e2');
  Color backgroundColor = HexColor.fromHex('f5f5f5');
  Color loginbackgroundColor = HexColor.fromHex('f4f4f6');
}
