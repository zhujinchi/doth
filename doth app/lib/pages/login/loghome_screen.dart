import 'package:doth/common/color_hex.dart';
import 'package:doth/pages/login/login_screen.dart';
import 'package:doth/pages/login/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/system_info.dart';

class LogHomeScreen extends StatefulWidget {
  const LogHomeScreen({Key? key}) : super(key: key);

  @override
  _LogHomeScreenState createState() => _LogHomeScreenState();
}

class _LogHomeScreenState extends State<LogHomeScreen> {
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
          _buildWelcomeText(),
          _buildRegisterView(),
          _buildLoginView(),
          _buildNotificationText()
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

  SliverToBoxAdapter _buildWelcomeText() {
    return SliverToBoxAdapter(
      child: Container(
        height: 180.w,
        child: Column(children: <Widget>[
          Text(
            'Doth',
            style: TextStyle(
              color: HexColor.fromHex('2a28a5'),
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            'WelCome!',
            style: TextStyle(
              color: HexColor.fromHex('1e1063'),
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            'Ready to launch?',
            style: TextStyle(
              color: HexColor.fromHex('2a28a5'),
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            'Sign in or create a account to start trading',
            style: TextStyle(
              color: HexColor.fromHex('2a28a5'),
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ]),
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
            EdgeInsets.only(left: 82.w, right: 82.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: () {
            gotoRegisterPage(context);
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
            "Join Doth",
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
            EdgeInsets.only(left: 82.w, right: 82.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: () {
            gotoLoginPage(context);
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
            "Login",
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

  SliverToBoxAdapter _buildNotificationText() {
    return SliverToBoxAdapter(
      child: Container(
        height: 180.w,
        padding: EdgeInsets.only(top: 20.w),
        child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 60.w),
                child: Icon(
                  Icons.question_mark_sharp,
                  size: 10.w,
                )),
            Padding(
                padding: EdgeInsets.only(left: 60.w, right: 60.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'The first 1,000 registrants pay a lump sum of \$100 to become a lifetime member.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor.fromHex('2a28a5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      'After 1,000 members, new members, in addition to paying \$100, are required to pay an annual fee of \$30 per year thereafter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor.fromHex('2a28a5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  gotoLoginPage(BuildContext context) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => const LoginScreen()));
  }

  gotoRegisterPage(BuildContext context) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => const RegisterScreen()));
  }
}
