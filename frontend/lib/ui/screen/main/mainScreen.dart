import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/model/screen/menu/option_list/bottom_nav_bar_options.dart';
import 'package:dentime/model/screen/menu/screen_index.dart';
import 'package:dentime/model/screen/menu/tab_icon_item.dart';
import 'package:dentime/ui/screen/booking/bookingScreen.dart';
import 'package:dentime/ui/screen/map/dentist_map.dart';
import 'package:dentime/ui/screen/profile/profile.dart';
import 'package:dentime/ui/screen/upcoming_bookings/upcoming_bookings_list.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_card.dart';
import 'package:dentime/ui/widget/drawer/drawer.dart';
import 'package:dentime/ui/widget/navigation_bar.dart/navigation_bar.dart';
import 'package:dentime/ui/widget/notification/main_screen_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<TabIconItem> _bottomNavTabIconsList =
      BottomNavBarTabIconData.tabIconsList;
  Widget _mainTabBody = Container();
  ScreenIndex _screenIndex;

  @override
  void initState() {
    super.initState();
    setMainBody(_bottomNavTabIconsList[0].index);
  }

  @override
  Widget build(BuildContext context) {
    Log.d("MainScreen building");
    return Scaffold(
      key: Provider.of<NavigationManager>(context, listen: false)
          .drawerKey, // assign key to Scaffold
      drawer: MainDrawer(
          // screenIndex: _screenIndex,
          // callBackIndex: (ScreenIndex index) => {setMainBody(index)},
          ),
      // Bottom nav bar
      body: Stack(
        children: [
          _mainTabBody,
          Positioned(
            bottom: 0,
            left: 0,
            child: NavigationBar(
              tabIconsList: _bottomNavTabIconsList,
              onCenterButtonClick: () {
                Log.d('Navigation bar FAB pressed');
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoPopupSurface(
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: DentistCard(
                        setMainBody: setMainBody,
                      ),
                    ),
                  ),
                );
              },
              changeIndex: (ScreenIndex index) {
                setMainBody(index);
              },
            ),
          ),
          Center(child: MainScreenNotifications()),
        ],
      ),
    );
  }

  void setMainBody(ScreenIndex index) {
    Log.i('Switching to $index');
    setState(() {
      _screenIndex = index;
      switch (index) {
        case ScreenIndex.DentistMap:
          _mainTabBody = DentistMap();
          break;
        case ScreenIndex.UpcomingBookings:
          _mainTabBody = UpcomingBookingsList();
          break;
        case ScreenIndex.MyProfile:
          _mainTabBody = Profile();
          break;
        case ScreenIndex.NewBooking:
          _mainTabBody = BookingScreen();
          break;
      }
      setBottomNavTab(index);
    });
  }

  void setBottomNavTab(ScreenIndex index) {
    _bottomNavTabIconsList.forEach((TabIconItem tab) {
      tab.isSelected = false;
      if (index == tab.index) {
        tab.isSelected = true;
      }
    });
  }

// // Notification popup
//   void _showDialog(context) {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: DentimeApplicationTheme.nearlyBlack,
//           title: Text("Confirmation"),
//           content: Text(
//             '',
//             textAlign: TextAlign.center,
//           ),
//           actions: <Widget>[
//             FlatButton(
//                 child: const Text('Confirm'),
//                 onPressed: () => Navigator.pop(context)),
//           ],
//         );
//       },
//     );
//   }
}
