import 'package:dentime/manager/api/mqtt/MQTTManager.dart';
import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/manager/user/user_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/model/user.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:dentime/ui/widget/time_slider/time_slider.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ClinicIsSelected extends StatefulWidget {
  @override
  _ClinicIsSelectedState createState() => _ClinicIsSelectedState();
}

class _ClinicIsSelectedState extends State<ClinicIsSelected> {
  DatePickerController _controller = DatePickerController();
  bool _dateFlag;
  bool _timeFlag;

  DateTime _selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = Provider.of<UserManager>(context).currentUser;
    final Clinic clinic =
        Provider.of<NavigationManager>(context).currentDentist;

    //TODO: Get actual available time slots here
    List<RadioModel> hourList = [];
    String selectedTime = DateUtil.getFormatedTimeString(_selectedTime);
    clinic.availability.forEach((availableTime) {
      if (DateUtil.isSameDate(_selectedTime, availableTime) &&
          availableTime.isAfter(DateTime.now())) {
        bool selected = false;
        String buttonText = DateUtil.getFormatedTimeString(availableTime);
        if (selectedTime == buttonText) {
          selected = true;
        }
        hourList.add(RadioModel(selected, buttonText));
      }
    });

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () {
            _controller.animateToSelection();
          },
        ),
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: MenuIcon(),
          ),
          backgroundColor: DentimeApplicationTheme.appBar,
          title: Text('Book An Appointment'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      Provider.of<NavigationManager>(context, listen: false)
                          .setCurrentDentist(null);
                      _dateFlag = false;
                      _timeFlag = false;
                      print(_dateFlag);
                      print(_timeFlag);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 20,
                    ),
                  ),
                ],
              ),
              Text('Your Dentist: ${clinic.name}',
                  style: DentimeApplicationTheme.bodyText1),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text(_selectedTime.toString(),
                  style: DentimeApplicationTheme.headline6),
              Padding(
                padding: EdgeInsets.all(20),
              ),
              Container(
                child: Column(
                  children: [
                    DatePicker(
                      DateTime.now(),
                      width: 60,
                      height: 80,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.black,
                      selectedTextColor: Colors.white,
                      activeDates: clinic.availability,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          _selectedTime = date;
                          _dateFlag = true;
                          _timeFlag = false;
                          print(_dateFlag);
                          print(_timeFlag);
                        });
                      },
                    ),
                    _dateFlag == true
                        ? Center(
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              child: TimeSlider(
                                onPressed: (String date) {
                                  setState(() {
                                    _selectedTime = _selectedTime.add(Duration(
                                        hours: int.parse(date.substring(0, 2)) -
                                            _selectedTime.hour,
                                        minutes:
                                            int.parse(date.substring(3, 5)) -
                                                _selectedTime.minute));
                                    Log.d(_selectedTime.toString());
                                    _timeFlag = true;
                                    print(_timeFlag);
                                  });
                                },
                                separation: 10,
                                hoursList: hourList,
                                height: 37,
                                width: 70,
                                textColor: Colors.black,
                                selectedTextColor: Colors.white,
                                color: Colors.red,
                                selectedColor: Colors.blue,
                              ),
                            ),
                          )
                        : Container(),
                    _timeFlag == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              color: Colors.black,
                              child: TextButton(
                                onPressed: () => {
                                  //TODO: Print the selected date and time
                                  Provider.of<MQTTManager>(context,
                                          listen: false)
                                      .subscribe(
                                          topic:
                                              'bookings/created/${currentUser.id}'),
                                  Provider.of<MQTTManager>(context,
                                          listen: false)
                                      .subscribe(
                                          topic:
                                              'bookings/failed/${currentUser.id}'),
                                  Provider.of<MQTTManager>(context,
                                          listen: false)
                                      .publish("bookings/create",
                                          "{\"dentistid\":  \"${clinic.id}\", \"userid\":  \"${currentUser.id}\", \"time\":  \"${_selectedTime.toIso8601String()}\", \"requestid\":  \"${Uuid().v4()}\", \"issuance\":  \"${DateTime.now().millisecondsSinceEpoch}\"}"),
                                  Provider.of<NavigationManager>(context,
                                          listen: false)
                                      .setCurrentDentist(null),
                                  //Navigator.of(context).pop(),
                                  EasyLoading.show(
                                    status: 'Finding available time...',
                                    maskType: EasyLoadingMaskType.black,
                                    dismissOnTap: true,
                                  ),
                                },
                                child: Text(
                                  'Book an Appointment',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              color: Colors.grey[400],
                              child: TextButton(
                                child: Text(
                                  'Pick a date and time',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
