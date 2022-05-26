import 'package:dentime/ui/screen/upcoming_bookings/upcoming_bookings_row.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  @override
  _UpcomingBookingsScreenState createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    Log.i('_UpcomingBookingsScreenState is building');
    //TODO: make this the page that is displayed, change according to the booking view flag just like dentist.
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: MenuIcon(),
        ),
        backgroundColor: DentimeApplicationTheme.appBar,
        title: Text('Upcoming Bookings'),
      ),
      body: Container(
          child: ListView.builder(
        // itemCount: bookings.length,
        itemCount: 5,
        itemBuilder: (context, position) {
          return UpcomingBookingsRow(
            position: position,
            // booking: bookings[position],
          );
        },
      )),
    );
  }
}
