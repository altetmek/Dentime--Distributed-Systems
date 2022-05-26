import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/ui/screen/booking/bookingClinicNotSelected.dart';
import 'package:dentime/ui/screen/booking/bookingClinicSelected.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Clinic clinic = Provider.of<NavigationManager>(context).currentDentist;

    return Expanded(
      child: clinic == null ? ClinicNotSelected() : ClinicIsSelected(),
    );
  }
}
