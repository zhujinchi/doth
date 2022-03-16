import 'dart:ffi';

class SystemInfo {
  SystemInfo._privateConstructor();

  static final SystemInfo _instance = SystemInfo._privateConstructor();

  static SystemInfo shared() {
    return _instance;
  }

  //系统信息
  late Double statusBarHeight;
  late Double bottomBarHeight;
}
