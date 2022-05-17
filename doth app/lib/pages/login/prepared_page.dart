import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../../data/system_info.dart';

class PreparedPage extends StatefulWidget {
  const PreparedPage({Key? key}) : super(key: key);

  @override
  _PreparedPageState createState() => _PreparedPageState();
}

class _PreparedPageState extends State<PreparedPage> {
  static List<dynamic> jsonData = [];

  String hash = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(390, 844),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      backgroundColor: SystemInfo.shared().loginbackgroundColor,
      //内容区域
      body: CustomScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildLogoView(),
          _buildRegisterView(),
          _buildtest3View(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildLogoView() {
    return SliverToBoxAdapter(
        child: Container(
            height: 250.w,
            padding: EdgeInsets.only(top: 100.w),
            child: Center(
                child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color.fromRGBO(192, 192, 192, 0.5)
                                  .withOpacity(0.2),
                              offset: Offset(2.2.w, 2.2.w), //阴影xy轴偏移量
                              blurRadius: 7.7.w, //阴影模糊程度
                              spreadRadius: 10 //阴影扩散程度
                              )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.w),
                      child: Image.asset(
                        'assets/icons/logo.png',
                      ),
                    )))));
  }

  SliverToBoxAdapter _buildRegisterView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(
        top: 0.w,
      ),
      child: Container(
        width: 390.w,
        height: 66.w,
        padding:
            EdgeInsets.only(left: 82.w, right: 82.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: () {
            test();
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: SystemInfo.shared().themeColor,
            side: BorderSide(
              width: 0.5.w,
              color: SystemInfo.shared().themeColor,
            ),
          ),
          child: Text(
            "getAbi",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17.5.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0),
          ),
        ),
      ),
    ));
  }

  SliverToBoxAdapter _buildtest3View() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(
        top: 0.w,
      ),
      child: Container(
        width: 390.w,
        height: 66.w,
        padding:
            EdgeInsets.only(left: 82.w, right: 82.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: () {
            //setIntialLTV();

            //deposit();
            //borrow();
            //withdraw();
            //repayByCollateral();

            getTotalTokens();
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            side: BorderSide(
              width: 0.5.w,
              color: SystemInfo.shared().themeColor,
            ),
          ),
          child: Text(
            "setIntialLTV",
            style: TextStyle(
                color: SystemInfo.shared().themeColor,
                fontSize: 17.5.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0),
          ),
        ),
      ),
    ));
  }

  loadJson() async {
    String jsonContent = await rootBundle.loadString("assets/json/abi.json");
    SystemInfo.jsonData = jsonContent;
    print(SystemInfo.jsonData);

    // var dio = Dio();
    // Response response = await dio.get(
    //     'https://api-kovan.etherscan.io/api?module=contract&action=getsourcecode&address=0xd0a1e359811322d97991e03f863a0c30c2cf029c&apikey=J9X1N328EU7FG42MRUMVNE35A264APAQ3S');
    // print(response.data['result']['ABI']);
  }

  void getABIwithToken() async {
    var dio = Dio();
    dio.options.receiveTimeout = 15000;
    String url =
        "https://api-kovan.etherscan.io/api?module=contract&action=getsourcecode&address=0xd0a1e359811322d97991e03f863a0c30c2cf029c&apikey=J9X1N328EU7FG42MRUMVNE35A264APAQ3S";

    var response = await dio.get(url);

    print(response.data['result'][0]['ABI']);

    getNameWithToken(response.data['result'][0]['ABI']);
    approve(response.data['result'][0]['ABI']);
  }

  getNameWithToken(String abi) async {
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client()); //

    final credentials =
        EthPrivateKey.fromHex(SystemInfo.shared().privateKey); //

    final address = credentials.address; //

    final contract = DeployedContract(ContractAbi.fromJson(abi, ''),
        EthereumAddress.fromHex('0xd0a1e359811322d97991e03f863a0c30c2cf029c'));

    final symbol = contract.function('symbol');

    var res =
        await client.call(contract: contract, function: symbol, params: []);

    print(res);
    await client.dispose();
  }

  approve(String abi) async {
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(ContractAbi.fromJson(abi, ''),
        EthereumAddress.fromHex('0xd0a1e359811322d97991e03f863a0c30c2cf029c'));

    final approve = contract.function('approve');

    var res = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: approve,
            parameters: [SystemInfo.shared().doth_address, BigInt.from(6600)]),
        chainId: 42);

    hash = res;

    print(res + 'current');

    await client.dispose();
  }

  test() {
    //getABIwithToken();
    loadJson();
  }

  ///Smart Contract write
  ///setIntialLTV   ok!
  // setIntialLTV() async {
  //   final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

  //   final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
  //   //final address = credentials.address;
  //   final contract = DeployedContract(
  //       ContractAbi.fromJson(SystemInfo.jsonData, ''),
  //       SystemInfo.shared().doth_address);

  //   final setIntialLTV = contract.function('setIntialLTV');

  //   var res = await client.sendTransaction(
  //       credentials,
  //       Transaction.callContract(
  //           contract: contract,
  //           function: setIntialLTV,
  //           parameters: [BigInt.from(6600)]),
  //       chainId: 42);

  //   hash = res;

  //   print(res + 'current');

  //   await client.dispose();
  // }

  ///deposit ok！
  deposit() async {
    //approve！！！

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
              [
                EthereumAddress.fromHex(
                    "0xd0a1e359811322d97991e03f863a0c30c2cf029c"),
                EthereumAddress.fromHex(
                    "0x4f96fe3b7a6cf9725f59d353f723c1bdb64ca6aa")
              ],
              BigInt.from(10)
            ]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///borrow ok
  borrow() async {
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
            parameters: [BigInt.from(10)]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///withdraw ok
  withdraw() async {
    final client = Web3Client(SystemInfo.shared().rpcUrl, Client());

    final credentials = EthPrivateKey.fromHex(SystemInfo.shared().privateKey);
    final address = credentials.address;
    final contract = DeployedContract(
        ContractAbi.fromJson(SystemInfo.jsonData, ''),
        SystemInfo.shared().doth_address);

    final withdraw = contract.function('withdraw');

    var res = await client.sendTransaction(
        credentials,
        Transaction
            .callContract(contract: contract, function: withdraw, parameters: [
          EthereumAddress.fromHex("0xd0a1e359811322d97991e03f863a0c30c2cf029c"),
          BigInt.from(10)
        ]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///repayByCollateral

  repayByCollateral() async {
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
            parameters: [SystemInfo.shared().tokenList, BigInt.from(1000)]),
        chainId: 42);

    print(res);

    await client.dispose();
  }

  ///Read part
  ///getTotalTokens ok！

  getTotalTokens() async {
    print('object');
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

    print(message);

    await client.dispose();
  }
}
