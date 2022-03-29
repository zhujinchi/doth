import 'package:doth/pages/login/loghome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../../common/color_hex.dart';
import '../../data/system_info.dart';
import '../../data/user.dart';

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
      backgroundColor: SystemInfo.shared().backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Doth',
          style: TextStyle(
              color: SystemInfo.shared().themeColor,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xffffffff),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 1.w,
      ),
      //内容区域
      body: CustomScrollView(
        //physics: const NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          _buildTitleView(),
          _buildInfoTopView(),
          _buildInfoBottomView()
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTitleView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
        child: Container(
            height: 80.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromRGBO(192, 192, 192, 0.5)
                          .withOpacity(0.2),
                      offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                      blurRadius: 7.7.w, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                      )
                ]),
            child: Padding(
              padding: EdgeInsets.only(top: 5.w, left: 10.w, right: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      gotoLoghomePage(context);
                    },
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/icons/profile_defaultIcon.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Lifetime Membership',
                          style: TextStyle(
                            color:
                                SystemInfo.shared().themeColor.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 6.w),
                        Text(
                          'Zhimei Chen',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoTopView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
        child: Container(
            height: 155.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
                boxShadow: [
                  BoxShadow(
                      color: const Color.fromRGBO(192, 192, 192, 0.5)
                          .withOpacity(0.21),
                      offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                      blurRadius: 7.7.w, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                      )
                ]),
            child: Padding(
              padding: EdgeInsets.only(top: 7.w),
              child: Column(
                children: <Widget>[
                  buildCellWith(
                      'assets/icons/profile_list_phone.png', '+86 18668135973'),
                  buildLine(),
                  buildCellWith('assets/icons/profile_list_email.png',
                      'zche3338@uni.sydney.edu.au'),
                  buildLine(),
                  buildCellWith(
                      'assets/icons/profile_list_card.png', '****4402'),
                ],
              ),
            )),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoBottomView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
          height: 155.w,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.w)),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromRGBO(192, 192, 192, 0.5)
                        .withOpacity(0.2),
                    offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                    blurRadius: 7.7.w, //阴影模糊程度
                    spreadRadius: 0 //阴影扩散程度
                    )
              ]),
          child: Padding(
            padding: EdgeInsets.only(top: 7.w),
            child: Column(
              children: <Widget>[
                buildCellWith('assets/icons/profile_list_info.png',
                    'Account Information'),
                buildLine(),
                buildCellWith('assets/icons/profile_list_service.png',
                    'Customer service'),
                buildLine(),
                buildCellWith('assets/icons/profile_list_other.png', 'Others'),
              ],
            ),
          )),
    ));
  }

  Widget buildCellWith(String icon, String title) {
    return Container(
      width: 350.w,
      height: 40.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40.w,
            height: 40.w,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.centerRight,
            child: Image.asset(
              icon,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLine() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, top: 5.w, right: 5.w, bottom: 5.w),
      child: Divider(
        color: Colors.grey[400],
        height: 0.w,
        thickness: 0.5.w,
        indent: 11.w,
        endIndent: 11.w,
      ),
    );
  }

  gotoLoghomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const LogHomeScreen()),
        (route) => route == null);
  }
}
