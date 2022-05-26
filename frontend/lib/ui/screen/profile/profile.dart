import 'package:dentime/ui/screen/past_bookings/past_bookings_list.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.blue[100],
                    height: 100,
                    width: 100,
                  ),
                ),
                Column(children: [
                  Container(
                    child: Text('Name'),
                  ),
                  Container(
                    child: SizedBox(
                        width: 100,
                        height: 20,
                        child: Divider(
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    child: Text('E-mail'),
                  )
                ])
              ],
            ),
            Center(child: Text('Past Bookings')),
            SizedBox(
                width: 300,
                child: Divider(
                  height: 20,
                  color: Colors.white,
                )),
            Expanded(child: PastBookingsList())
          ],
        ),
      ),
    );
  }
}
//'Profile\n${Provider.of<ClinicManager>(context).clinics[1].name}'
