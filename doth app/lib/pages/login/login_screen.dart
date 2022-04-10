import 'package:doth/common/color_hex.dart';
import 'package:doth/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/system_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passWordEditingController =
      TextEditingController();

  final TextEditingController _accountEditingController =
      TextEditingController();

  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: SystemInfo.shared().loginbackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 30, 16, 99),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),

      body: CustomScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildWelcomeText(),
          _buildAccountInputView(),
          _buildPasswordInputView(),
          _buildConfirmView(),
          _buildLoginView()
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildWelcomeText() {
    return SliverToBoxAdapter(
      child: Container(
        height: 140.w,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            'Go to ',
            style: TextStyle(
              color: HexColor.fromHex('1e1063'),
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
            ),
          ),
          Text(
            'Doth',
            style: TextStyle(
              color: HexColor.fromHex('6a67ca'),
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
            ),
          ),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildAccountInputView() {
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
                          controller: _accountEditingController,
                          showCursor: true,
                          maxLines: 1,
                          maxLength: 12,
                          autofocus: false,
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: false,
                            counterText: '',
                            hintText: 'Email or phone number',
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
                          EdgeInsets.only(left: 250.w, top: 4.w, right: 30.w),
                      child: _accountEditingController.text.isNotEmpty
                          ? IconButton(
                              //如果文本长度不为空则显示清除按钮
                              onPressed: () {
                                setState(() {
                                  _accountEditingController.clear();
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
                      color: Colors.grey[300],
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

  SliverToBoxAdapter _buildPasswordInputView() {
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
                      padding: EdgeInsets.only(left: 280.w, top: 5.w),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(passwordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        color: Colors.grey,
                      )),
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
                          controller: _passWordEditingController,
                          showCursor: true,
                          maxLines: 1,
                          maxLength: 12,
                          autofocus: false,
                          obscureText: !passwordVisible,
                          style: TextStyle(fontSize: 18.w),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: false,
                            counterText: '',
                            hintText: 'password',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
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
                          EdgeInsets.only(left: 250.w, top: 4.w, right: 30.w),
                      child: _passWordEditingController.text.isNotEmpty
                          ? IconButton(
                              //如果文本长度不为空则显示清除按钮
                              onPressed: () {
                                setState(() {
                                  _passWordEditingController.clear();
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
                      color: Colors.grey[300],
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

  SliverToBoxAdapter _buildConfirmView() {
    return SliverToBoxAdapter(
      child: Container(
        height: 100.w,
      ),
    );
  }

  SliverToBoxAdapter _buildLoginView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(
        top: 0.w,
      ),
      child: Container(
        width: 390.w,
        height: 66.w,
        padding:
            EdgeInsets.only(left: 32.w, right: 32.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: _accountEditingController.text.length >= 11 &&
                  _passWordEditingController.text.length >= 6
              ? () {
                  gotoHomePage(context);
                }
              : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: _accountEditingController.text.length >= 11 &&
                    _passWordEditingController.text.length >= 6
                ? SystemInfo.shared().themeColor
                : Colors.grey.withOpacity(0.3),
            side: BorderSide(
              width: 0.5.w,
              color: _accountEditingController.text.length >= 11 &&
                      _passWordEditingController.text.length >= 6
                  ? SystemInfo.shared().themeColor
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            "Log in",
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
