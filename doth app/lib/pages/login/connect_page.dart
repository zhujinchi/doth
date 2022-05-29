import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doth/common/Contract.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../../common/color_hex.dart';
import '../../data/system_info.dart';
import '../../home_page.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final TextEditingController _privateKeyEditingController =
      TextEditingController();

  static List<dynamic> jsonData = [];

  String hash = '';

  @override
  initState() {
    loadJson();
    getlocallog();
    super.initState();
  }

  getlocallog() async {
    final prefs = await SharedPreferences.getInstance();
    final String? privatekey = prefs.getString('privatekey');
    if (privatekey != null && privatekey.isNotEmpty) {
      _privateKeyEditingController.text = privatekey;
    }
    setState(() {});
  }

  loadJson() async {
    String jsonContent = await rootBundle.loadString("assets/json/abi.json");
    SystemInfo.jsonData = jsonContent;

    String erc20jsonContent =
        await rootBundle.loadString("assets/json/erc20.json");
    SystemInfo.erc20jsonData = erc20jsonContent;
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
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: CustomScrollView(
            //physics: const NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              _buildLogoView(),
              _buildPrivateKeyInputView(),
              _buildConnectView(),
            ],
          ),
        ));
  }

  SliverToBoxAdapter _buildLogoView() {
    return SliverToBoxAdapter(
        child: Container(
            height: 250.w,
            padding: EdgeInsets.only(top: 100.w),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80.w,
                    height: 80.w,
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
                    )),
                Container(
                    width: 40.w,
                    child: VerticalDivider(
                      width: 1.w,
                      color: Colors.grey,
                      indent: 40.w,
                      endIndent: 40.w,
                    )),
                Container(
                    width: 80.w,
                    height: 80.w,
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
                        'assets/icons/metamask_logo.png',
                      ),
                    ))
              ],
            ))));
  }

  SliverToBoxAdapter _buildPrivateKeyInputView() {
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.only(top: 30.w, left: 35.w, right: 35.w),
            child: Column(
              children: [
                Text('Paste your private key here.',
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.w,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.w)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 6.w),
                        child: Container(
                            width: 240.w,
                            height: 120.w,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor.fromHex('5C8987'),
                              cursorHeight: 18.w,
                              cursorRadius: Radius.circular(2.w),
                              cursorWidth: 2.w,
                              controller: _privateKeyEditingController,
                              showCursor: true,
                              maxLines: 5,
                              maxLength: 100,
                              autofocus: false,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: false,
                                counterText: '',
                                hintText: 'Paste your private key here',
                                hintStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              onSubmitted: (str) {},
                              textInputAction: TextInputAction.done,
                              onChanged: (content) {
                                setState(() {});
                              },
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 270.w, top: 69.w, right: 30.w),
                          child: _privateKeyEditingController.text.isNotEmpty
                              ? IconButton(
                                  //如果文本长度不为空则显示清除按钮
                                  onPressed: () {
                                    setState(() {
                                      _privateKeyEditingController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.cancel_rounded,
                                      size: 20.w,
                                      color: Colors.grey.withOpacity(0.4)),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                )
                              : null),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 30.w, top: 55.w, right: 30.w),
                        child: Divider(
                          color: Colors.grey[300]!.withOpacity(0),
                          height: 0.w,
                          thickness: 0.5.w,
                          indent: 11.w,
                          endIndent: 11.w,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }

  SliverToBoxAdapter _buildConnectView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(
        top: 10.w,
      ),
      child: Container(
        width: 390.w,
        height: 66.w,
        padding:
            EdgeInsets.only(left: 35.w, right: 35.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: _privateKeyEditingController.text.isNotEmpty
              ? () async {
                  SystemInfo.shared().privateKey =
                      _privateKeyEditingController.text;

                  if (Contract().checkkey(_privateKeyEditingController.text)) {
                    MyToast.show(
                        'The public-private key is verified successfully.');
                    connectStep();
                    getpreparedinfo();
                  } else {
                    MyToast.show('Public key private key verification failed.');
                    return;
                  }
                }
              : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: _privateKeyEditingController.text.isNotEmpty
                ? SystemInfo.shared().themeColor
                : Colors.grey.withOpacity(0.3),
            side: BorderSide(
              width: 0.5.w,
              color: _privateKeyEditingController.text.isNotEmpty
                  ? SystemInfo.shared().themeColor
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            "Connect",
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

  connectStep() async {
    //share preference
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('privatekey', _privateKeyEditingController.text);
  }

  getpreparedinfo() async {
    var res = [];
    res = await Contract().getTotalTokens();

    for (int i = 0; i < SystemInfo.shared().tokenList.length; i++) {
      List temp = await Contract()
          .getNameWithToken(SystemInfo.shared().tokenList[i].toString());

      if (!SystemInfo.shared().nameList.contains(temp[0])) {
        SystemInfo.shared().nameList.add(temp[0]);
      }
    }

    print(SystemInfo.shared().nameList);

    if (SystemInfo.shared().nameList.isNotEmpty) {
      MyToast.show('Connect Success');
      gotoHomePage(context);
    } else {
      MyToast.show('check your network!');
    }
  }

  gotoHomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const HomePage()),
        (route) => route == null);
  }
}
