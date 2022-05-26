import 'package:dentime/manager/location/location_manager.dart';
import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_list.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_view.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:dentime/manager/clinic/clinic_manager.dart';
import 'package:dentime/model/clinic.dart';
import 'package:dentime/ui/theme/dentime.dart';

class DentistCard extends StatefulWidget {
  const DentistCard({
    Key key,
    this.setMainBody,
  }) : super(key: key);

  final Function setMainBody;
  @override
  _DentistCardState createState() => _DentistCardState();
}

class _DentistCardState extends State<DentistCard> {
  /*_setSelectedDentist(Clinic dentist) {
    setState(() {
      _selectedDentist = dentist;
      Log.d(dentist.toString());
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final Clinic _selectedDentist =
        Provider.of<NavigationManager>(context).currentDentist;

    final size = MediaQuery.of(context).size;
    final LatLng position =
        Provider.of<LocationManager>(context).currentPosition;
    final List<Clinic> clinics =
        Provider.of<ClinicManager>(context).getSortedClinics(position);
    return Stack(children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 15),
                  color: DentimeApplicationTheme.nearlyWhite,
                  width: 85,
                  height: 2,
                ),
              ),
              _selectedDentist == null
                  ? DentistList(
                      size: size,
                      clinics: clinics,
                    )
                  : DentistView(
                      setMainBody: widget.setMainBody,
                    ),
            ],
          ),
        ),
      ),
    ]);
  }
}
