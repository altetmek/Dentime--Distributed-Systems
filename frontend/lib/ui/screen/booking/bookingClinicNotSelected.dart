import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/manager/location/location_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ClinicNotSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final LatLng position =
        Provider.of<LocationManager>(context).currentPosition;
    final List<Clinic> clinics =
        Provider.of<ClinicManager>(context).getSortedClinics(position);
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
        title: Text('Book An Appointment'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DentistList(size: size, clinics: clinics),
          ),
        ],
      ),
    );
  }
}
