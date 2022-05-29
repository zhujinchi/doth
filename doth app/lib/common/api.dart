import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:doth/data/system_info.dart';

class API {
  dynamic register(String firstname, String lastname, String phoneNumber,
      String email, String password, String publicKey) async {
    MyToast.notice('register api start');

    String url = "http://1.14.103.90:5000/register";

    ///build Dio
    Dio dio = Dio();

    ///md5
    String passwordmd5 = md5.convert(utf8.encode(password)).toString();

    ///build map
    Map<String, dynamic> map = {};
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['telephone'] = phoneNumber;
    map['email'] = email;
    map['password'] = passwordmd5;
    map['public_key'] = publicKey;

    ///发起post请求
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;
    print(data);

    return data;
  }

  dynamic login(String email, String password) async {
    MyToast.notice('login api start');

    String url = "http://1.14.103.90:5000/login";

    ///build Dio
    Dio dio = Dio();

    ///md5
    String passwordmd5 = md5.convert(utf8.encode(password)).toString();

    ///build map
    Map<String, dynamic> map = {};

    map['email'] = email;
    map['password'] = passwordmd5;

    ///发起post请求
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;

    return data;
  }

  buildtransection(double amount) {}

  transferByPaypal(double amount) {}

  repayByUSD(double amount) {}

  Future<String> getPaypalAccount() async {
    MyToast.notice('getPaypalAccount api start');

    print('getPaypalAccount api start');

    String url = "http://1.14.103.90:5000/paypal_wallet";

    ///build Dio
    Dio dio = Dio();

    dio.options.headers['Authorization'] = SystemInfo.shared().token;

    ///发起get请求
    Response response = await dio.get(url);

    var data = response.data;

    if (data['code'] == 0) {
    } else if (data['code'] == -1) {
      MyToast.show('Login token expired. Please try to log in again');
    } else {
      MyToast.show('Check your network');
    }

    return data['data']['USD'];
  }
}
