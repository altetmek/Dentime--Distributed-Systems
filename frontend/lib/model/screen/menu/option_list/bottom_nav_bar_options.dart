import 'package:dentime/model/screen/menu/screen_index.dart';
import 'package:dentime/model/screen/menu/tab_icon_item.dart';
import 'package:flutter/material.dart';

class BottomNavBarTabIconData {
  static List<TabIconItem> tabIconsList = <TabIconItem>[
    TabIconItem(
      icon: Icons.pin_drop_outlined,
      index: ScreenIndex.DentistMap,
      isSelected: true,
    ),
    /*TabIconItem(
      icon: Icons.insert_invitation_outlined,
      index: ScreenIndex.UpcomingBookings,
      isSelected: false,
    ),*/
    TabIconItem(
      icon: Icons.wysiwyg_outlined,
      index: ScreenIndex.NewBooking,
      isSelected: false,
    ),
    TabIconItem(
      icon: Icons.event_available_outlined,
      index: ScreenIndex.UpcomingBookings,
      isSelected: false,
    ),
    TabIconItem(
      icon: Icons.account_circle_outlined,
      index: ScreenIndex.MyProfile,
      isSelected: false,
    ),
    // TabIconItem(
    //   imagePath: 'assets/images/icons/dentime/icon.svg',
    //   selectedImagePath: 'assets/images/icons/dentime/icon.svg',
    //   index: ScreenIndex.Screen,
    //   isSelected: false,
    // ),
  ];
}
