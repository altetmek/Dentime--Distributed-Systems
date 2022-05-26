import 'package:flutter/material.dart';

class PastBookingsHeading extends StatelessWidget {
  PastBookingsHeading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    "Clinic",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(
                    "Duration",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 4,
        ),
      ],
    );
  }
}
