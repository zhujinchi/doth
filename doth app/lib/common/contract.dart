import 'package:dio/dio.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../../data/system_info.dart';

class Contract {
  void getABIwithToken(String tokenaddress) async {
    var dio = Dio();
    dio.options.receiveTimeout = 15000;
    String url =
        "https://api-kovan.etherscan.io/api?module=contract&action=getsourcecode&address=" +
            tokenaddress +
            "&apikey=J9X1N328EU7FG42MRUMVNE35A264APAQ3S";

    var response = await dio.get(url);

    getNameWithToken(response.data['result'][0]['ABI'], tokenaddress);

    // approve(response.data['result'][0]['ABI']);
  }

  getNameWithToken(String abi, String tokenaddress) async {
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client()); //

    final credentials =
        EthPrivateKey.fromHex(SystemInfo.shared().privateKey); //

    final address = credentials.address;

    final contract = DeployedContract(
        ContractAbi.fromJson(abi, ''), EthereumAddress.fromHex(tokenaddress));

    final symbol = contract.function('symbol');

    var res =
        await client.call(contract: contract, function: symbol, params: []);

    MyToast.info(res.toString());

    await client.dispose();
  }

  approve(String abi, String tokenaddress) async {
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
            parameters: [SystemInfo.shared().doth_address, BigInt.from(6600)]),
        chainId: 42);

    print(res + 'current');

    await client.dispose();
  }

  ///deposit ok！
  deposit(List addressList, int amount) async {
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
            parameters: [addressList, BigInt.from(amount)]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///borrow ok
  borrow(int amount) async {
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
            parameters: [BigInt.from(amount)]),
        chainId: 42);

    MyToast.info('borrow:' + res);

    await client.dispose();
  }

  ///withdraw ok
  withdraw(String tokenaddress, int amount) async {
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
    print('getTotalTokens');
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

    return message;
  }

  Future<List> getLTV() async {
    print('getLTV');
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
        params: [
          EthereumAddress.fromHex('0x6595cd432df8693C6b9f4e318Ea4A452614C726B')
        ]);

    MyToast.info('getLTV:' + message.toString());

    return message;
  }
}
