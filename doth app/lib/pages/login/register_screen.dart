import 'dart:ffi';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:doth/common/api.dart';
import 'package:doth/common/color_hex.dart';
import 'package:doth/home_page.dart';
import 'package:doth/pages/login/loghome_screen.dart';
import 'package:doth/pages/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/system_info.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passWordEditingController =
      TextEditingController();

  final TextEditingController _phoneEditingController = TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _firstnameEditingController =
      TextEditingController();

  final TextEditingController _lastnameEditingController =
      TextEditingController();

  final TextEditingController _publicKeyEditingController =
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
              _buildWelcomeText(),
              _buildNameInputView(),
              _buildPhoneInputView(),
              _buildEmailInputView(),
              _buildPasswordInputView(),
              _buildPublicKeyInputView(),
              _buildConfirmView(),
              _buildRegisterView()
            ],
          ),
        ));
  }

  SliverToBoxAdapter _buildWelcomeText() {
    return SliverToBoxAdapter(
      child: Container(
        height: 80.w,
        child: Column(
          children: [
            Text(
              'Create Your',
              style: TextStyle(
                color: HexColor.fromHex('1e1063'),
                fontWeight: FontWeight.bold,
                fontSize: 28.sp,
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                'Doth ',
                style: TextStyle(
                  color: HexColor.fromHex('6a67ca'),
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              ),
              Text(
                'Account',
                style: TextStyle(
                  color: HexColor.fromHex('1e1063'),
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNameInputView() {
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.only(top: 30.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 0.w, top: 6.w),
                        child: Container(
                            width: 155.w,
                            height: 50.w,
                            padding: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w))),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor.fromHex('5C8987'),
                              cursorHeight: 18.w,
                              cursorRadius: Radius.circular(2.w),
                              cursorWidth: 2.w,
                              controller: _firstnameEditingController,
                              showCursor: true,
                              maxLines: 1,
                              maxLength: 9,
                              autofocus: false,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: false,
                                counterText: '',
                                hintText: 'First name',
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
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 0.w, top: 6.w),
                        child: Container(
                            width: 155.w,
                            height: 50.w,
                            padding: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w))),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor.fromHex('5C8987'),
                              cursorHeight: 18.w,
                              cursorRadius: Radius.circular(2.w),
                              cursorWidth: 2.w,
                              controller: _lastnameEditingController,
                              showCursor: true,
                              maxLines: 1,
                              maxLength: 9,
                              autofocus: false,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: false,
                                counterText: '',
                                hintText: 'Last name',
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
                    ],
                  ),
                ],
              ),
            )));
  }

  SliverToBoxAdapter _buildPhoneInputView() {
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
                          keyboardType: TextInputType.number,
                          cursorColor: HexColor.fromHex('5C8987'),
                          cursorHeight: 18.w,
                          cursorRadius: Radius.circular(2.w),
                          cursorWidth: 2.w,
                          controller: _phoneEditingController,
                          showCursor: true,
                          maxLines: 1,
                          maxLength: 11,
                          autofocus: false,
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: false,
                            counterText: '',
                            hintText: 'Enter your number(11)',
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
                      child: _phoneEditingController.text.isNotEmpty
                          ? IconButton(
                              //如果文本长度不为空则显示清除按钮
                              onPressed: () {
                                setState(() {
                                  _phoneEditingController.clear();
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

  SliverToBoxAdapter _buildEmailInputView() {
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
                          controller: _emailEditingController,
                          showCursor: true,
                          maxLines: 1,
                          maxLength: 30,
                          autofocus: false,
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: false,
                            counterText: '',
                            hintText: 'Enter your email(>=6)',
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
                      child: _emailEditingController.text.isNotEmpty
                          ? IconButton(
                              //如果文本长度不为空则显示清除按钮
                              onPressed: () {
                                setState(() {
                                  _emailEditingController.clear();
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
                      padding: EdgeInsets.only(left: 265.w, top: 5.w),
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
                          maxLength: 16,
                          autofocus: false,
                          obscureText: !passwordVisible,
                          style: TextStyle(fontSize: 18.w),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: false,
                            counterText: '',
                            hintText: 'password(>=6)',
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
                          EdgeInsets.only(left: 235.w, top: 4.w, right: 30.w),
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

  SliverToBoxAdapter _buildPublicKeyInputView() {
    return SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.only(top: 30.w, left: 35.w, right: 35.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.w)),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color.fromRGBO(192, 192, 192, 0.5)
                                          .withOpacity(0.2),
                                  offset: Offset(2.2.w, 2.2.w), //阴影xy轴偏移量
                                  blurRadius: 7.7.w, //阴影模糊程度
                                  spreadRadius: 1 //阴影扩散程度
                                  )
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.w),
                          child: Image.asset(
                            'assets/icons/metamask_logo.png',
                          ),
                        )),
                    SizedBox(width: 10.w),
                    Text('Input your metamask public key',
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
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
                            height: 70.w,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: HexColor.fromHex('5C8987'),
                              cursorHeight: 18.w,
                              cursorRadius: Radius.circular(2.w),
                              cursorWidth: 2.w,
                              controller: _publicKeyEditingController,
                              showCursor: true,
                              maxLines: 2,
                              maxLength: 50,
                              autofocus: false,
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: false,
                                counterText: '',
                                hintText: 'Paste your public key here',
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
                              left: 270.w, top: 29.w, right: 30.w),
                          child: _publicKeyEditingController.text.isNotEmpty
                              ? IconButton(
                                  //如果文本长度不为空则显示清除按钮
                                  onPressed: () {
                                    setState(() {
                                      _publicKeyEditingController.clear();
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

  SliverToBoxAdapter _buildConfirmView() {
    return SliverToBoxAdapter(
      child: Container(
        height: 20.w,
      ),
    );
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
            EdgeInsets.only(left: 32.w, right: 32.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: getcheck()
              ? () async {
                  var res = await API().register(
                      _firstnameEditingController.text,
                      _lastnameEditingController.text,
                      _phoneEditingController.text,
                      _emailEditingController.text,
                      _passWordEditingController.text,
                      _publicKeyEditingController.text);

                  print(res);

                  if (res['code'] == 0) {
                    showOkAlertDialog(
                            context: context, title: 'Register Success')
                        .then((value) {
                      gotoLoginHomePage(context);
                    });
                  } else if (res['code'] == -1) {
                    showOkAlertDialog(
                        context: context,
                        title: 'Register Failed',
                        message:
                            'mobile phone number, email address or public key has been registered');
                  } else {
                    showOkAlertDialog(
                        context: context,
                        title: 'Register Failed',
                        message: 'Check your network');
                  }
                }
              : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: getcheck()
                ? SystemInfo.shared().themeColor
                : Colors.grey.withOpacity(0.3),
            side: BorderSide(
              width: 0.5.w,
              color: getcheck()
                  ? SystemInfo.shared().themeColor
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Text(
            "Create account",
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

  bool getcheck() {
    return _phoneEditingController.text.length == 11 &&
        _passWordEditingController.text.length >= 6 &&
        _firstnameEditingController.text.isNotEmpty &&
        _lastnameEditingController.text.isNotEmpty &&
        _emailEditingController.text.length >= 6 &&
        _publicKeyEditingController.text.isNotEmpty;
  }

  gotoLoginHomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const LogHomeScreen()),
        (route) => route == null);
  }
}
