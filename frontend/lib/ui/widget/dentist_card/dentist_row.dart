import 'package:dentime/manager/location/location_manager.dart';
import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:dentime/model/clinic.dart';
import 'package:dentime/model/openinghours.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DentistRow extends StatelessWidget {
  const DentistRow({
    Key key,
    @required this.totalLength,
    @required this.position,
    @required this.clinic,
  }) : super(key: key);

  final Clinic clinic;
  final int position;
  final int totalLength;

  @override
  Widget build(BuildContext context) {
    final LatLng currentPosition =
        Provider.of<LocationManager>(context).currentPosition;
    DateTime date = DateTime.now();
    //TODO: This probably won't work on a Swedish phone
    String dayString = 'Day.' + DateFormat('EEEE').format(date).toLowerCase();
    // Log.d('Day of the week: $dayString');
    OpeningHours openingHours = clinic.openingHours.firstWhere(
      (element) => element.day.toString() == dayString,
      orElse: () => (Log.d(
          'addClinic: No opening hours found for ${clinic.name} on $dayString')),
    );
    LatLng point;
    double distanceTo = clinic.distanceFrom(currentPosition);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Provider.of<NavigationManager>(context, listen: false)
                .setCurrentDentist(clinic);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_outlined,
                  size: 22,
                ),
                SizedBox(width: 5),
                Container(
                    width: 55,
                    child: distanceTo > 999
                        // divided by 100 and then 10 gets us to kilometers in an ugly way, can be improved
                        ? Text('${(distanceTo / 100).roundToDouble() / 10} km')
                        : Text('${distanceTo.round()} m')),
                Container(
                  width: MediaQuery.of(context).size.width - 210,
                  child: Text(
                    clinic.name,
                  ),
                ),
                Container(
                  width: 80,
                  child: Text(
                      openingHours != null ? openingHours.hours : 'CLOSED',
                      textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
        ),
        position != totalLength - 1
            ? Divider(
                height: 2,
                thickness: 2,
              )
            : Container(),
      ],
    );
  }
}
