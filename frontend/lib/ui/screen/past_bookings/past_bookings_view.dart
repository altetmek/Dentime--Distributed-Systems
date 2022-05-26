import 'package:flutter/material.dart';

class DentistView extends StatelessWidget {
  const DentistView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          color: Colors.white,
          child: Text('Your Booking for ... <-FILL THIS'),
        ),
        Container(
          height: 100,
          width: double.infinity,
          color: Colors.white10,
          child: Text('DATE OF APPOINTMENT HERE IN BIG TEXT'),
        ),
        Container(
          height: 100,
          width: double.infinity,
          child: Text('COUNTDOWN TO THE APPOINTMENT TIME'),
        ),
        //TODO: Use cards here??
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 100,
              width: 100,
              color: Colors.grey[350],
              child: Text('Cancel this meeting'),
            ),
            SizedBox(
              height: 100,
              width: 10,
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.grey[350],
              child: Text('Change the booking time'),
            ),
            SizedBox(
              height: 100,
              width: 10,
            ),
            Container(
              height: 100,
              width: 100,
              color: Colors.grey[350],
              child: Text('ADD MORE HERE??'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
              color: Colors.grey,
              child: TextButton(
                  onPressed: null,
                  child: Text('GET DIRECTIONS FROM GOOGLE MAPS',
                      style: TextStyle(color: Colors.white)))),
        ),
        Container(
          height: 100,
          width: double.infinity,
          child: Text('idk more??????'),
        )
      ],
    );
  }
}
