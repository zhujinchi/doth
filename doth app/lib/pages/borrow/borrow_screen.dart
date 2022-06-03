import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:doth/common/Contract.dart';
import 'package:doth/common/api.dart';
import 'package:doth/data/system_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/color_hex.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({Key? key}) : super(key: key);

  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final TextEditingController _amountBorrowedEditingController =
      TextEditingController();

  String _pavalue = '';

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() async {
    var res = await Contract().apr();
    BigInt temp = res[0];

    setState(() {
      //_pavalue = res[0] / BigInt.from(pow(10, 6)).toRadixString(2);
      _pavalue = (temp.toInt() / 1000000).toString();
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
                _buildBorrowView(),
                //_buildMortgageView(),
                _buildCollectionView(),
                _buildConfirmButton()
              ],
            ),
          ),
        ));
  }

  SliverToBoxAdapter _buildBorrowView() {
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
            child: Row(
              children: [
                Text(
                  'I need to borrow',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  '',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 122.w),
            child: Row(
              children: [
                Text(
                  _pavalue,
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  '% p.a. Expected to arrive within 2hours',
                  style: TextStyle(
                    color: Colors.black87.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 28.w, top: 72.w),
            child: SizedBox(
                width: 260.w,
                height: 40.w,
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  cursorColor: HexColor.fromHex('5C8987'),
                  cursorHeight: 18.w,
                  cursorRadius: Radius.circular(2.w),
                  cursorWidth: 2.w,
                  controller: _amountBorrowedEditingController,
                  showCursor: true,
                  maxLines: 1,
                  maxLength: 20,
                  autofocus: false,
                  style: TextStyle(fontSize: 18.w),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: false,
                    counterText: '',
                    hintText: 'Enter the amount borrowed',
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
              child: _amountBorrowedEditingController.text.isNotEmpty
                  ? SizedBox(
                      width: 30.w,
                      height: 30.w,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _amountBorrowedEditingController.clear();
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

  SliverToBoxAdapter _buildCollectionView() {
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
                'Collection',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 23.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 66.w, left: 20.w),
              child: Container(
                width: 35.w,
                height: 35.w,
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/icons/borrow_paypal.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 64.w, right: 24.w, top: 76.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Paypal',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 23.sp,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.access_time_filled_sharp,
                    color: Colors.black87.withOpacity(0.3),
                    size: 20.w,
                  )
                ],
              ),
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

  SliverToBoxAdapter _buildConfirmButton() {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.only(bottom: 40.w),
      child: Container(
        width: 390.w,
        height: 70.w,
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 15.w, bottom: 0.w),
        child: OutlinedButton(
          onPressed: _amountBorrowedEditingController.text.isNotEmpty
              ? () async {
                  await Contract().borrow(
                      double.parse(_amountBorrowedEditingController.text));

                  await API().buildtransection(double.parse(
                      _amountBorrowedEditingController.text.toString()));

                  showOkAlertDialog(context: context, title: 'Borrow success');
                  _amountBorrowedEditingController.clear();
                }
              : null,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),
            backgroundColor: _amountBorrowedEditingController.text.isNotEmpty
                ? SystemInfo.shared().themeColor
                : Colors.grey.withOpacity(0.3),
            side: BorderSide(
                width: 0.5.w,
                color: _amountBorrowedEditingController.text.isNotEmpty
                    ? SystemInfo.shared().themeColor
                    : Colors.grey.withOpacity(0.3)),
          ),
          child: Text(
            "Confirm the borrow",
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
}
