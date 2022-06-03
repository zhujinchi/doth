import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../../data/system_info.dart';

class Contract {
  Future<List> getNameWithToken(String tokenaddress) async {
    //MyToast.notice('');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client()); //

    final credentials =
        EthPrivateKey.fromHex(SystemInfo.shared().privateKey); //

    final address = credentials.address;

    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.erc20jsonData, ''),
        EthereumAddress.fromHex(tokenaddress));

    final symbol = contract.function('symbol');

    var res =
        await client.call(contract: contract, function: symbol, params: []);

    //MyToast.info(res.toString());

    await client.dispose();
    return res;
  }

  Future<bool> approve(String abi, String tokenaddress, double amount) async {
    MyToast.notice('approve api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, ''), EthereumAddress.fromHex(tokenaddress));

    final approve = contract.function('approve');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: approve,
            parameters: [
              SystemInfo.shared().doth_address,
              BigInt.from(amount * pow(10, 18))
            ]),
        chainId: 42);

    MyToast.info('approve:' + res.toString());

    for (int i = 0; i < 11; i++) {
      var transactionInfo = await client.getTransactionReceipt(res.toString());
      sleep(const Duration(seconds: 3));
      if (transactionInfo != null) {
        MyToast.info('approve done!');
        await client.dispose();
        return true;
      } else {
        MyToast.notice('Waiting for the response of approve!\n' +
            'Time:' +
            i.toString() +
            '/10');
      }
    }
    await client.dispose();
    return false;
  }

  ///deposit ok！
  deposit(String tokenaddress, double amount) async {
    print(tokenaddress);
    print(amount);
    MyToast.notice('deposit api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final deposit = contract.function('deposit');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: deposit,
            parameters: [
              EthereumAddress.fromHex(tokenaddress),
              BigInt.from(amount * pow(10, 18))
            ]),
        chainId: 42);

    print(res);
    MyToast.info('deposit:' + res.toString());
    await client.dispose();
  }

  ///borrow ok
  borrow(double amount) async {
    MyToast.notice('borrow api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final borrow = contract.function('borrow');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: borrow,
            parameters: [BigInt.from(amount * pow(10, 2))]),
        chainId: 42);

    MyToast.info('borrow:' + res);

    await client.dispose();
  }

  bool checkkey(String privatekey) {
    final credentials = EthPrivateKey.fromHex(privatekey);
    final address = credentials.address;

    // print(address);
    // print(SystemInfo.shared().public_key);

    if (address.toString().toLowerCase() ==
        SystemInfo.shared().public_key.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  Uint8List encode(String s) {
    var encodedString = utf8.encode(s);
    var encodedLength = encodedString.length;
    var data = ByteData(encodedLength + 4);
    data.setUint32(0, encodedLength, Endian.big);
    var bytes = data.buffer.asUint8List();
    bytes.setRange(4, encodedLength + 4, encodedString);
    return bytes;
  }

  ///withdraw ok
  withdraw(String tokenaddress, int amount) async {
    MyToast.notice('withdraw api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final withdraw = contract.function('withdraw');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: withdraw,
            parameters: [
              EthereumAddress.fromHex(tokenaddress),
              BigInt.from(amount)
            ]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///repayByCollateral

  repayByCollateral(int amount) async {
    MyToast.notice('repayByCollateral api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final repayByCollateral = contract.function('repayByCollateral');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: repayByCollateral,
            parameters: [SystemInfo.shared().tokenList, BigInt.from(amount)]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///Read part
  ///getTotalTokens
  Future<List> getTotalTokens() async {
    MyToast.notice('getTotalTokens api start');
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getTotalTokens = contract.function('getTotalTokens');

    var message = await client
        .call(contract: contract, function: getTotalTokens, params: []);

    SystemInfo.shared().tokenList = message[0];
    SystemInfo.shared().amountList = message[1];

    MyToast.info('getTotalTokens:' + message.toString());
    await client.dispose();
    return message;
  }

  Future<List> getLTV() async {
    MyToast.notice('getLTV api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getLTV = contract.function('getLTV');

    var message = await client.call(
        contract: contract,
        function: getLTV,
        params: [EthereumAddress.fromHex(SystemInfo.shared().public_key)]);

    MyToast.info('getLTV:' + message.toString());
    await client.dispose();
    return message;
  }

  Future<List> apr() async {
    MyToast.notice('APR api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final APR = contract.function('APR');

    var message =
        await client.call(contract: contract, function: APR, params: []);

    MyToast.info('APR:' + message.toString());
    await client.dispose();
    return message;
  }

  Future<List> apy() async {
    MyToast.notice('APY api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getLTV = contract.function('APY');

    var message =
        await client.call(contract: contract, function: getLTV, params: []);

    MyToast.info('APY:' + message.toString());
    await client.dispose();
    return message;
  }

  Future<int> getUserSingleTokenAmount(String tokenaddress) async {
    MyToast.notice('getUserSingleTokenAmount api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getUserSingleTokenAmount =
        contract.function('getUserSingleTokenAmount');

    var message = await client
        .call(contract: contract, function: getUserSingleTokenAmount, params: [
      EthereumAddress.fromHex(SystemInfo.shared().public_key),
      EthereumAddress.fromHex(tokenaddress)
    ]);

    await client.dispose();
    BigInt temp = message[0];
    return temp.toInt();
  }

  Future<int> getUserSingleTokenValue(String tokenaddress) async {
    MyToast.notice('getUserSingleTokenValue api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getUserSingleTokenValue =
        contract.function('getUserSingleTokenValue');

    var message = await client
        .call(contract: contract, function: getUserSingleTokenValue, params: [
      EthereumAddress.fromHex(SystemInfo.shared().public_key),
      EthereumAddress.fromHex(tokenaddress)
    ]);

    await client.dispose();
    BigInt temp = message[0];
    return temp.toInt();
  }

  Future<int> getUserLoanValue() async {
    MyToast.notice('getUserLoanValue api start');

    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final getUserLoanValue = contract.function('getUserLoanValue');

    var message = await client.call(
        contract: contract,
        function: getUserLoanValue,
        params: [EthereumAddress.fromHex(SystemInfo.shared().public_key)]);

    await client.dispose();
    BigInt temp = message[0];
    return temp.toInt();
  }
}
