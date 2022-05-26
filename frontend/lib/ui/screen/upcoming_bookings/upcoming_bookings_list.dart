import 'package:dentime/manager/api/mqtt/MQTTManager.dart';
import 'package:dentime/manager/booking/booking_manager.dart';
import 'package:dentime/manager/user/user_manager.dart';
import 'package:dentime/model/booking.dart';
import 'package:dentime/model/user.dart';
import 'package:dentime/ui/screen/upcoming_bookings/upcoming_bookings_list_heading.dart';
import 'package:dentime/ui/screen/upcoming_bookings/upcoming_bookings_row.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingBookingsList extends StatelessWidget {
  const UpcomingBookingsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.i('UpcomingBookingsList is building');

    final User currentUser = Provider.of<UserManager>(context).currentUser;
    Provider.of<MQTTManager>(context, listen: false)
        .subscribe(topic: 'bookings/${currentUser.id}');
    final bookings = Provider.of<BookingManager>(context).getUpcomingBookings();

    List<Widget> rows = List<Widget>();

    int i = 0;
    int length = bookings.length;
    for (Booking booking in bookings) {
      Widget row = UpcomingBookingsRow(
        length: length,
        position: i,
        booking: booking,
      );
      rows.insert(rows.length, row);
      ++i;
    }

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
        child: ListView(
          children: [
            UpcomingBookingsHeading(),
            ...rows,
            SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
