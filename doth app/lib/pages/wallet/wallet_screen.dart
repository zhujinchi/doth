import 'package:doth/common/contract.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/system_info.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  String ltvValue = '';

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    List<dynamic> res = await Contract().getLTV();
    setState(() {
      ltvValue = res.toString();
    });
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
          backgroundColor: const Color(0xffffffff),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 1.w,
          title: Text(
            'Doth',
            style: TextStyle(
                color: SystemInfo.shared().themeColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        //内容区域
        body: EasyRefresh(
          onRefresh: () async {
            _refresh();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _buildLTVView(),
              _buildAssetsView(),
              _buildDepositAssetsView(),
            ],
          ),
        ));
  }

  SliverToBoxAdapter _buildLTVView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
        height: 85.w,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
            boxShadow: [
              BoxShadow(
                  color:
                      const Color.fromRGBO(192, 192, 192, 0.5).withOpacity(0.2),
                  offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                  blurRadius: 7.7.w, //阴影模糊程度
                  spreadRadius: 0 //阴影扩散程度
                  )
            ]),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'My LTV',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Text(
                ltvValue,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  SliverToBoxAdapter _buildAssetsView() {
    List<Widget> render = [];
    render.add(Text(
      'My deposit assets',
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
    ));

    render.add(SizedBox(
      height: 10.w,
    ));

    for (var item in SystemInfo.shared().nameList) {
      render.add(Container(
        padding: EdgeInsets.only(top: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: TextStyle(
                color: Colors.black87.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '数量',
                  style: TextStyle(
                    color: Colors.black87.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '价值',
                  style: TextStyle(
                    color: Colors.black87.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 80.w,
                  height: 24.w,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      backgroundColor: SystemInfo.shared().themeColor,
                      side: BorderSide(
                          width: 0.5.w, color: SystemInfo.shared().themeColor),
                    ),
                    child: Text(
                      "withdraw",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ));
    }
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
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
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: render),
          )),
    ));
  }

  SliverToBoxAdapter _buildDepositAssetsView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
            boxShadow: [
              BoxShadow(
                  color:
                      const Color.fromRGBO(192, 192, 192, 0.5).withOpacity(0.2),
                  offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                  blurRadius: 7.7.w, //阴影模糊程度
                  spreadRadius: 0 //阴影扩散程度
                  )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'My Loan',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 20.w),
            Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  '¥2000',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.w),
            Container(
                width: 320.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150.w,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          backgroundColor: SystemInfo.shared().subthemeColor,
                          side: BorderSide(
                              width: 0.5.w,
                              color: SystemInfo.shared().subthemeColor),
                        ),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(
                              color: SystemInfo.shared().themeColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      width: 150.w,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          backgroundColor: SystemInfo.shared().themeColor,
                          side: BorderSide(
                              width: 0.5.w,
                              color: SystemInfo.shared().themeColor),
                        ),
                        child: Text(
                          "Make a deposit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    ));
  }
}
