import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:doth/data/system_info.dart';
import 'package:doth/data/user.dart';

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

    ///post
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

    ///post
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;

    return data;
  }

  Future<String> buildtransection(double amount) async {
    MyToast.notice('buildtransection api start');

    String url = "http://1.14.103.90:5000/paypal_create";

    ///build Dio
    Dio dio = Dio();

    dio.options.headers['Authorization'] = SystemInfo.shared().token;

    ///build map
    Map<String, dynamic> map = {};

    map['amount_USD'] = amount.toString();

    ///post
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;

    print(data);

    if (data['code'] == 0) {
    } else if (data['code'] == -1) {
      MyToast.show('Login token expired. Please try to log in again');
    } else {
      MyToast.show('Check your network');
    }

    if (data['code'] == 0) {
      MyToast.info('build paypal transaction successfully');
      User.shared().deal_id = data['data']['id'].toString();
      transferByPaypal(data['data']['id'].toString());
    } else {
      MyToast.info('build paypal transaction fail');
    }

    return '';
  }

  transferByPaypal(String id) async {
    MyToast.notice('transferByPaypal api start');

    String url = "http://1.14.103.90:5000/paypal_borrow";

    ///build Dio
    Dio dio = Dio();

    dio.options.headers['Authorization'] = SystemInfo.shared().token;

    ///build map
    Map<String, dynamic> map = {};

    map['deal_id'] = id;

    ///post
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;

    print(data);

    if (data['code'] == 0) {
    } else if (data['code'] == -1) {
      MyToast.show('Login token expired. Please try to log in again');
    } else {
      MyToast.show('Check your network');
    }

    if (data['code'] == 0) {
      MyToast.show('Borrow money to your paypal account successfully');
    } else {
      MyToast.show(
          'Borrow money to your paypal account fail, check your network or your token account');
    }
  }

  repayByUSD(double amount) async {
    MyToast.notice('repayByUSD api start');

    String url = "http://1.14.103.90:5000/paypal_return";

    ///build Dio
    Dio dio = Dio();

    dio.options.headers['Authorization'] = SystemInfo.shared().token;

    ///build map
    Map<String, dynamic> map = {};

    map['deal_id'] = User.shared().deal_id;
    map['amount_USD'] = amount;

    ///post
    Response response = await dio.post(url, queryParameters: map);

    var data = response.data;

    print(data);

    if (data['code'] == 0) {
    } else if (data['code'] == -1) {
      MyToast.show('Login token expired. Please try to log in again');
    } else {
      MyToast.show('Check your network');
    }

    if (data['code'] == 0) {
      MyToast.show('Repay money from your paypal account successfully');
    } else {
      MyToast.show(
          'Repay money from your paypal account fail, check your network or your token account');
    }
  }

  Future<String> getPaypalAccount() async {
    MyToast.notice('getPaypalAccount api start');

    print('getPaypalAccount api start');

    String url = "http://1.14.103.90:5000/paypal_wallet";

    ///build Dio
    Dio dio = Dio();

    dio.options.headers['Authorization'] = SystemInfo.shared().token;

    ///get
    Response response = await dio.get(url);

    var data = response.data;

    print(data);

    if (data['code'] == 0) {
    } else if (data['code'] == -1) {
      MyToast.show('Login token expired. Please try to log in again');
    } else {
      MyToast.show('Check your network');
    }

    return data['data']['USD'];
  }
}
