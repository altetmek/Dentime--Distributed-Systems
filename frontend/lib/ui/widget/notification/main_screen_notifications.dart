import 'package:dentime/manager/booking/booking_manager.dart';
import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/model/booking.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreenNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Booking newBooking = Provider.of<BookingManager>(context).newBooking;
    final bookedClinic = newBooking != null
        ? Provider.of<ClinicManager>(context).getClinicById(newBooking.dentist)
        : null;
    // final isLoading = Provider.of<NavigationManager>(context).isLoading;
    return Stack(
      children: [
        // booking notification
        newBooking != null
            ? AlertDialog(
                backgroundColor: DentimeApplicationTheme.nearlyBlack,
                title: Text("Booking Confirmation"),
                content: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(text: 'Booking at '),
                      TextSpan(
                          text: '${bookedClinic.name}',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: '\nconfirmed for: '),
                      TextSpan(
                          text:
                              '${DateUtil.getFormatedTimeString(newBooking.time)}',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      TextSpan(text: '\non: '),
                      TextSpan(
                          text: '${DateUtil.getDateString(newBooking.time)}',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                    ])),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () =>
                        Provider.of<BookingManager>(context, listen: false)
                            .removeNewBooking(),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
