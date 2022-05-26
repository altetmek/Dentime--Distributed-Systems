import 'package:dentime/model/clinic.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_row.dart';
import 'package:flutter/material.dart';

class DentistList extends StatelessWidget {
  const DentistList({
    Key key,
    @required this.size,
    @required this.clinics,
  }) : super(key: key);

  final Size size;
  final List<Clinic> clinics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Dentists", style: DentimeApplicationTheme.headline5),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          height: size.height > 600 ? size.height - 265 : 400,
          // height: 500,
          width: double.infinity,
          child: ListView.builder(
            itemCount: clinics.length,
            itemBuilder: (context, position) {
              return DentistRow(
                position: position,
                clinic: clinics[position],
                totalLength: clinics.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
