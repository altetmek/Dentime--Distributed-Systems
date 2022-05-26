import 'package:dentime/manager/api/mqtt/MQTTManager.dart';
import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/manager/user/user_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/model/screen/menu/screen_index.dart';
import 'package:dentime/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DentistView extends StatefulWidget {
  const DentistView({
    Key key,
    this.setMainBody,
  }) : super(key: key);

  final Function setMainBody;

  @override
  _DentistViewState createState() => _DentistViewState();
}

class _DentistViewState extends State<DentistView> {
  bool _bookButtonEnabled = true;

  enableBookAsapButton(bool bookButtonEnabled) {
    setState(() {
      _bookButtonEnabled = bookButtonEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<UserManager>(context).currentUser;
    Clinic clinic = Provider.of<NavigationManager>(context).currentDentist;
    return new Expanded(
      child: ListView(shrinkWrap: true, children: [
        Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: FlatButton(
                onPressed: () {
                  Provider.of<NavigationManager>(context, listen: false)
                      .setCurrentDentist(null);
                },
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 20,
                ),
              ),
              title: Text(clinic.name),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/dentist_images/dentist1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/dentist_images/dentist2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/dentist_images/dentist3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    color: Colors.grey,
                    child: TextButton(
                      onPressed: _bookButtonEnabled
                          ? () => {
                                Provider.of<MQTTManager>(context, listen: false)
                                    .subscribe(
                                        topic:
                                            'bookings/created/${currentUser.id}'),
                                Provider.of<MQTTManager>(context, listen: false)
                                    .subscribe(
                                        topic:
                                            'bookings/failed/${currentUser.id}'),
                                Provider.of<MQTTManager>(context, listen: false)
                                    .publish("bookings/nextAvailable",
                                        "{\"dentistid\":  \"${clinic.id}\", \"userid\":  \"${currentUser.id}\"}"),
                                // Disable booking button to prevent duplicate bokings
                                enableBookAsapButton(false),
                                Provider.of<NavigationManager>(context,
                                        listen: false)
                                    .setCurrentDentist(null),
                                Navigator.of(context).pop(),
                                EasyLoading.show(
                                  status: 'Finding available time...',
                                  maskType: EasyLoadingMaskType.black,
                                  dismissOnTap: true,
                                ),
                              }
                          : null,
                      child: Text(
                        'Book ASAP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    color: Colors.grey,
                    child: TextButton(
                      onPressed: () => {
                        Provider.of<NavigationManager>(context, listen: false)
                            .setMainScreenContext(
                                widget.setMainBody(ScreenIndex.NewBooking)),
                      },
                      child: Text(
                        'Pick a time',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 2,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Monday: ${clinic.openingHours[0].hours}'),
                            Text('Tuesday: ${clinic.openingHours[1].hours}'),
                            Text('Wednesday: ${clinic.openingHours[2].hours}'),
                            Text('Thursday: ${clinic.openingHours[3].hours}'),
                            Text('Friday: ${clinic.openingHours[4].hours}'),
                            Text(
                              clinic.openingHours.length < 6
                                  ? 'Saturday: CLOSED'
                                  : clinic.openingHours[5].hours,
                            ),
                            Text(
                              clinic.openingHours.length < 7
                                  ? 'Sunday: CLOSED'
                                  : clinic.openingHours[6].hours,
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.55,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height * 0.292,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text('Available Dentists: ${clinic.dentists}'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height * 0.292,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child:
                          Text('Location: ${clinic.address}, ${clinic.city}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height * 0.292,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text('The Owner: ${clinic.owner}'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: MediaQuery.of(context).size.height * 0.292,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text('PUT MORE INFO IF NEEDED'),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
