import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/system_info.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      print(_tabController.index);
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
        bottom: TabBar(
          indicatorColor: SystemInfo.shared().themeColor,
          labelColor: Colors.black,
          indicatorPadding: EdgeInsets.only(left: 30.w, right: 30.w),
          controller: _tabController, // 4 需要配置 controller！！！
          // isScrollable: true,
          tabs: const <Widget>[
            Tab(text: 'Dashboard'),
            Tab(text: 'Liability'),
            Tab(text: 'Deposit'),
          ],
        ),
      ),
      //内容区域
      body: TabBarView(
        controller: _tabController, // 4 需要配置 controller！！！
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              _buildAccumulatedBorrowedView(false),
              _buildDepositbottomView(),
            ],
          ),
          CustomScrollView(
            slivers: <Widget>[
              _buildAccumulatedBorrowedView(true),
            ],
          ),
          CustomScrollView(
            slivers: <Widget>[
              _buildDepositAssetsView(),
              _buildDepositbottomView(),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildAccumulatedBorrowedView(bool isWithButton) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
        height: 345.w,
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
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.w, top: 18.w),
              child: Text(
                'Accumulated borroed',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.w, left: 20.w),
              child: Container(
                width: 35.w,
                height: 35.w,
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/icons/wallet_doller.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 174.w, right: 24.w, top: 76.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '31,132',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black87.withOpacity(0.3),
                    size: 20.w,
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 122.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Rate',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '3.5% p.a',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 152.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Borrowing time',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '10 days',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 182.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Interest Incurred',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '2336.5',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 260.w),
              child: isWithButton
                  ? Container(
                      width: 320.w,
                      height: 70.w,
                      padding: EdgeInsets.only(top: 15.w, bottom: 0.w),
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
                                backgroundColor:
                                    SystemInfo.shared().subthemeColor,
                                side: BorderSide(
                                    width: 0.5.w,
                                    color: SystemInfo.shared().subthemeColor),
                              ),
                              child: Text(
                                "Repayment",
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
                          SizedBox(
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
                                "Borrow more",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0),
                              ),
                            ),
                          )
                        ],
                      ))
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 113.w, right: 5.w),
              child: Divider(
                color: Colors.grey[400],
                height: 0.w,
                thickness: 0.5.w,
                indent: 11.w,
                endIndent: 11.w,
              ),
            )
          ],
        ),
      ),
    ));
  }

  SliverToBoxAdapter _buildDepositAssetsView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
        height: 345.w,
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
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 24.w, top: 18.w),
              child: Text(
                'My deposit assets',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70.w, left: 20.w),
              child: Container(
                width: 35.w,
                height: 35.w,
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/icons/borrow_btc.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 174.w, right: 24.w, top: 76.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'BTC',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                    ),
                  ),
                  Text(
                    '31,132',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black87.withOpacity(0.3),
                    size: 20.w,
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 122.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Rate',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '3.5% p.a',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 152.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Deposit time',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '10 days',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 182.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Accrued interest',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '2336.5',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 260.w),
              child: Container(
                  width: 320.w,
                  height: 70.w,
                  padding: EdgeInsets.only(top: 15.w, bottom: 0.w),
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
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 113.w, right: 5.w),
              child: Divider(
                color: Colors.grey[400],
                height: 0.w,
                thickness: 0.5.w,
                indent: 11.w,
                endIndent: 11.w,
              ),
            )
          ],
        ),
      ),
    ));
  }

  SliverToBoxAdapter _buildDepositbottomView() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
      child: Container(
          height: 65.w,
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
              padding: EdgeInsets.only(left: 20.w, right: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 35.w,
                    height: 35.w,
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/icons/wallet_eth.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    'ETH 51,132',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                    ),
                  ),
                ],
              ))),
    ));
  }
}
