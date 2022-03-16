class User {
  User._privateConstructor();

  static final User _instance = User._privateConstructor();

  static User shared() {
    return _instance;
  }

  //用户信息
  late String id;
  late String userName;
  late String userPhone;

  //设备是否支持
  bool canVibrate = true;
}
