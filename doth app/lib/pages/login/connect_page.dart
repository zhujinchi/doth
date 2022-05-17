import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doth/common/Contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  void initState() {
    loadJson();
    _privateKeyEditingController.text = SystemInfo.shared().privateKey;
    super.initState();
  }

  loadJson() async {
    String jsonContent = await rootBundle.loadString("assets/json/abi.json");
    SystemInfo.jsonData = jsonContent;
    print(SystemInfo.jsonData);
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
          _buildPrivateKeyInputView(),
          _buildConnectView(),
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
            child: Container(
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
                        height: 40.w,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: HexColor.fromHex('5C8987'),
                          cursorHeight: 18.w,
                          cursorRadius: Radius.circular(2.w),
                          cursorWidth: 2.w,
                          controller: _privateKeyEditingController,
                          showCursor: true,
                          maxLines: 2,
                          maxLength: 40,
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
                      padding:
                          EdgeInsets.only(left: 270.w, top: 4.w, right: 30.w),
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
                  var res = [];
                  res = await Contract().getTotalTokens();
                  if (res.isNotEmpty) {
                    gotoHomePage(context);
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

  gotoHomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const HomePage()),
        (route) => route == null);
  }
}
