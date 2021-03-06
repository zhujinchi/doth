import 'dart:ffi';

import 'package:doth/common/color_hex.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class SystemInfo {
  SystemInfo._privateConstructor();

  static final SystemInfo _instance = SystemInfo._privateConstructor();

  static SystemInfo shared() {
    return _instance;
  }

  //system info
  late Double statusBarHeight;
  late Double bottomBarHeight;
  Color themeColor = HexColor.fromHex('2927a4');
  Color subthemeColor = HexColor.fromHex('bec4e2');
  Color backgroundColor = HexColor.fromHex('f5f5f5');
  Color loginbackgroundColor = HexColor.fromHex('f4f4f6');

  static String jsonData = '';
  static String erc20jsonData = '';
  static String jsonDataDefault = '';

  ///

  String rpcUrl = 'https://kovan.infura.io/v3/e3b3cf0628f04f2c9e54ccd14355ff57';

  var doth_address =
      EthereumAddress.fromHex("0x80596450a684A8c43e57c1B246C690Cb85EA2138");

  var user_address =
      EthereumAddress.fromHex("0x42A56F3246f42530Ba4E18Dc13B7F2804908c6f6");

  List tokenList = [];
  List amountList = [];
  List<String> nameList = [];
  //List<String> abiList = [];
  List assetsAmount = [];
  List assetsList = [];

  //login information

  String token = '';
  //user
  String email = '';
  String firstname = '';
  String lastname = '';
  String telephone = '';
  String public_key = '';
  String privateKey = '';
}
