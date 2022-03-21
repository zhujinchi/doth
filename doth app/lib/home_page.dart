import 'package:doth/data/system_info.dart';
import 'package:doth/data/user.dart';
import 'package:doth/pages/profile/profile_page.dart';
import 'package:doth/pages/borrow/borrow_screen.dart';
import 'package:doth/pages/deposit/deposit_screen.dart';
import 'package:doth/pages/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'animated_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _inactiveColor = Colors.grey;

  //Color backgroundColor = const Color(0xff050B18);
  Color backgroundColor = const Color(0xffffffff);

  List<String> titles = ['Borrow', 'Deposit', 'Wallet', 'Profile'];
  List<String> bodyImages = [
    'assets/images/body_home.png',
    'assets/images/bo'
        'dy_search.png',
    'assets/images/body_rank.png',
    'assets/images/body_video.png'
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    User.shared().canVibrate = canVibrate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: _tabPages[_currentIndex],
        bottomNavigationBar: _buildBottomBar());
  }

  final _tabPages = <Widget>[
    const BorrowScreen(),
    const DepositScreen(),
    const WalletScreen(),
    const ProfileScreen()
  ];

  Widget _buildBottomBar() {
    return AnimatedBottomBar(
      containerHeight: 56,
      backgroundColor: backgroundColor,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 12,
      curve: Curves.easeInOut,
      onItemSelected: (index) {
        if (User.shared().canVibrate && _currentIndex != index) {
          Vibrate.feedback(FeedbackType.success);
        }
        setState(() => _currentIndex = index);
      },
      items: <MyBottomNavigationBarItem>[
        MyBottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/bottom_borrow.png',
            width: 24,
            height: 24,
          ),
          iconUnselected: Image.asset(
            'assets/icons/bottom_borrow_grey.png',
            width: 24,
            height: 24,
          ),
          title: Text(titles[0]),
          activeColor: SystemInfo.shared().themeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        MyBottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/bottom_deposit.png',
            width: 24,
            height: 24,
          ),
          iconUnselected: Image.asset(
            'assets/icons/bottom_deposit_grey.png',
            width: 24,
            height: 24,
          ),
          title: Text(titles[1]),
          activeColor: SystemInfo.shared().themeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        MyBottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/bottom_wallet.png',
            width: 24,
            height: 24,
          ),
          iconUnselected: Image.asset(
            'assets/icons/bottom_wallet_grey.png',
            width: 24,
            height: 24,
          ),
          title: Text(titles[2]),
          activeColor: SystemInfo.shared().themeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        MyBottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/bottom_profile.png',
            width: 24,
            height: 24,
          ),
          iconUnselected: Image.asset(
            'assets/icons/bottom_profile_grey.png',
            width: 24,
            height: 24,
          ),
          title: Text(titles[3]),
          activeColor: SystemInfo.shared().themeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
