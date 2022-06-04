import 'package:beerwarden/consts/app_color.dart';
import 'package:beerwarden/views/member_list_screen.dart';
import 'package:beerwarden/views/upcoming_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/notification_service.dart';


Future<void> main() async {
  await Hive.initFlutter();
  await NotificationService().init();
  runApp(const BeerWardenApp());
}

class BeerWardenApp extends StatefulWidget {
  const BeerWardenApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BeerWardenAppState();
}

class BeerWardenAppState extends State<BeerWardenApp> {
  static final List<Widget> _pages = <Widget>[
    UpcomingEventScreen(),
    MemberListScreen()
  ];

  static final List<String> _titles = ["Upcoming Events", "Members"];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      theme: ThemeData(
        primarySwatch: AppColor.primaryMaterialColor,
        primaryColor: AppColor.primary,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: _pages[_selectedIndex],
          appBar: AppBar(
            title: Text(_titles[_selectedIndex]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.event_available),
                label: 'Event',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Member")
            ],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
