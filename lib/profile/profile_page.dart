import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../common/color_hex.dart';
import '../data/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 17.5.w, color: Colors.black),
        ),
        backgroundColor: const Color(0xffffffff),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      //内容区域
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildPhoneView(),
          _buildAboutListView(),
          _buildVersionAndPrivacyView(),
          _buildLogOutView()
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildPhoneView() {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: 390.w,
        height: 55.w,
        //color: Colors.red,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 17.5.w, top: 15.w, bottom: 5.5.w),
              child: Icon(
                Icons.mail_outline_rounded,
                size: 27.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 55.w, top: 18.w),
              child: Text(
                '1397107033',
                style: TextStyle(
                  fontSize: 17.5.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 55.w),
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
      ),
    );
  }

  SliverToBoxAdapter _buildAboutListView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(
        top: 55.w,
      ),
      child: Column(
        children: <Widget>[
          _listCellModel('Messages'),
          _listCellModel('Account Settings'),
          _listCellModel('FeedBack'),
          _listCellModel('About')
        ],
      ),
    ));
  }

  Widget _listCellModel(String name) {
    return SizedBox(
        height: 55.w,
        child: InkWell(
            onTap: () {
              if (User.shared().canVibrate) {
                Vibrate.feedback(FeedbackType.light);
              }
            },
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 17.5.w, top: 16.5.w),
                  child: Text(
                    name,
                    style: TextStyle(
                        // color: Colors.grey[600],
                        fontSize: 17.5.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.w),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 352.w, top: 14.w, bottom: 5.5.w),
                  child: Icon(
                    Icons.chevron_right_sharp,
                    size: 27.5.w,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 55.w),
                  child: Divider(
                    color: Colors.grey[300],
                    height: 0.w,
                    thickness: 0.5.w,
                    indent: 11.w,
                    endIndent: 11.w,
                  ),
                )
              ],
            )));
  }

  SliverToBoxAdapter _buildVersionAndPrivacyView() {
    var paddingTop = MediaQuery.of(context).padding.top;
    var paddingBottom = MediaQuery.of(context).padding.bottom;
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 222.h - paddingTop - paddingBottom),
        width: 390.w,
        height: 55.w,
        padding: EdgeInsets.only(top: 16.5.w),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Version 0.0.1.1381',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Center(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: HexColor.fromHex('5C8987'),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w200,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (User.shared().canVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                    },
                ),
                TextSpan(
                  text: ',',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: HexColor.fromHex('5C8987'),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w200,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (User.shared().canVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                    },
                ),
                TextSpan(
                    text: 'and',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w200,
                    )),
                TextSpan(
                  text: 'Third Party Notices',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: HexColor.fromHex('5C8987'),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w200,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (User.shared().canVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                    },
                ),
              ])),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildLogOutView() {
    return SliverToBoxAdapter(
      child: Container(
        width: 390.w,
        height: 66.w,
        padding:
            EdgeInsets.only(left: 11.w, right: 11.w, top: 5.5.w, bottom: 5.5.w),
        child: OutlinedButton(
          onPressed: () {
            if (User.shared().canVibrate) {
              Vibrate.feedback(FeedbackType.success);
            }
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            side: BorderSide(
              width: 1.1.w,
              color: HexColor.fromHex('5C8987'),
            ),
          ),
          child: Text(
            "Sign Out",
            style: TextStyle(
                color: HexColor.fromHex('5C8987'),
                fontSize: 17.5.sp,
                letterSpacing: 0.w),
          ),
        ),
      ),
    );
  }
}
