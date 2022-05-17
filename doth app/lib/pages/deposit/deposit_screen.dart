import 'package:doth/common/contract.dart';
import 'package:doth/common/my_fluttertoast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web3dart/web3dart.dart';

import '../../common/color_hex.dart';
import '../../data/system_info.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController _amountDepositedEditingController =
      TextEditingController();

  List<String> _animals = ["Dog", "Cat", "Crocodile", "Dragon"];

  String? _selectedColor = 'wai';

  String _available = SystemInfo.shared().amountList[1].toString();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    Contract().getTotalTokens();
    // for (String items in SystemInfo.shared().tokenList) {
    //   Contract().getABIwithToken(items);
    // }
    //tokennameList = SystemInfo.shared().nameList;
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
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: EasyRefresh(
            onRefresh: () async {
              _refresh();
            },
            child: CustomScrollView(
              slivers: <Widget>[
                _buildPaywithView(),
                _buildDepositView(),
                _buildConfirmButton(),
                _buildNotificationText(),
              ],
            ),
          ),
        ));
  }

  SliverToBoxAdapter _buildPaywithView() {
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
                'Pay with',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 23.sp,
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
              padding: EdgeInsets.only(left: 64.w, right: 24.w, top: 46.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 260.w,
                      height: 50.w,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            value: _selectedColor,
                            items:
                                SystemInfo.shared().nameList.map((String kind) {
                              return DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Text(
                                      kind,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23.sp,
                                      ),
                                    ),
                                    // Text(
                                    //   " to be set",
                                    //   style: TextStyle(
                                    //     color: Colors.black87,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 23.sp,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                value: kind,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              _selectedColor = value.toString();
                              int i = SystemInfo.shared()
                                  .nameList
                                  .indexOf(value.toString());

                              _available =
                                  SystemInfo.shared().amountList[i].toString();
                              setState(() {});
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.w, top: 122.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Available:',
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      _available,
                      style: TextStyle(
                        color: Colors.black87.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                )),
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

  SliverToBoxAdapter _buildDepositView() {
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
                  color:
                      const Color.fromRGBO(192, 192, 192, 0.5).withOpacity(0.2),
                  offset: Offset(0, 2.2.w), //阴影xy轴偏移量
                  blurRadius: 7.7.w, //阴影模糊程度
                  spreadRadius: 0 //阴影扩散程度
                  )
            ]),
        child: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 24.w, top: 18.w),
            child: Text(
              'Deposit amount',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 23.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 122.w),
            child: Text(
              '3.5% p.a. Expected to arrive within 2hours',
              style: TextStyle(
                color: Colors.black87.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.w, top: 72.w),
            child: SizedBox(
                width: 260.w,
                height: 40.w,
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: HexColor.fromHex('5C8987'),
                  cursorHeight: 18.w,
                  cursorRadius: Radius.circular(2.w),
                  cursorWidth: 2.w,
                  controller: _amountDepositedEditingController,
                  showCursor: true,
                  maxLines: 1,
                  maxLength: 20,
                  autofocus: false,
                  style: TextStyle(fontSize: 18.w),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: false,
                    counterText: '',
                    hintText: 'Please enter the deposit amount',
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.5), fontSize: 18.w),
                  ),
                  onSubmitted: (str) {},
                  textInputAction: TextInputAction.done,
                  onChanged: (content) {
                    setState(() {});
                  },
                )),
          ),
          Padding(
              padding: EdgeInsets.only(left: 320.w, top: 78.w, right: 30.w),
              child: _amountDepositedEditingController.text.isNotEmpty
                  ? SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _amountDepositedEditingController.clear();
                          });
                        },
                        child: Icon(Icons.cancel_rounded,
                            size: 20.w, color: Colors.grey.withOpacity(0.4)),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    )
                  : null),
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
        ]),
      ),
    ));
  }

  SliverToBoxAdapter _buildConfirmButton() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(bottom: 00.w),
      child: Container(
        width: 390.w,
        height: 70.w,
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 15.w, bottom: 0.w),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: SystemInfo.shared().themeColor,
            side:
                BorderSide(width: 0.5.w, color: SystemInfo.shared().themeColor),
          ),
          child: Text(
            "Confirm the deposit",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
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
                padding: EdgeInsets.only(left: 40.w),
                child: Icon(
                  Icons.question_mark_sharp,
                  size: 10.w,
                )),
            Padding(
                padding: EdgeInsets.only(left: 50.w, right: 50.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'There is no upper limit on the deposit, no interest is paid for the',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor.fromHex('2a28a5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      'time being, and the withdrawal can be made at any time at the',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor.fromHex('2a28a5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      'daily interest rate.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: HexColor.fromHex('2a28a5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
