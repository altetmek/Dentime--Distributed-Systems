import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/manager/user/user_manager.dart';
import 'package:dentime/model/booking.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/model/user.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastBookingsRow extends StatelessWidget {
  PastBookingsRow({
    Key key,
    @required this.booking,
    @required this.position,
    @required this.length,
  }) : super(key: key);

  final Booking booking;
  final int length;
  final int position;

  @override
  Widget build(BuildContext context) {
    final Clinic clinic =
        Provider.of<ClinicManager>(context).getClinicById(booking.dentist);
    final User user = Provider.of<UserManager>(context).currentUser;

    return Column(
      children: [
        InkWell(
          onTap: () {
            // setSelectedDentist(clinic);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 100 * 36,
                  //TODO: This is hardcoded, fix.
                  child: Text(clinic.name),
                ),
                Container(
                  child: Text(
                    "${DateUtil.getFormatedTimeString(booking.time)} on ${DateUtil.getDateString(booking.time)}",
                  ),
                ),
                Container(
                  child: Text(
                    booking.duration.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
        position != length - 1
            ? Divider(
                height: 2,
                thickness: 2,
              )
            : Container(),
      ],
    );
  }
}
