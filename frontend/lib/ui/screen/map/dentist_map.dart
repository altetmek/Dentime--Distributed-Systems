import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/app_bar/menu_icon.dart';
import 'package:dentime/ui/widget/dentist_card/dentist_card.dart';
import 'package:dentime/ui/widget/dentist_map/dentist_map.dart';
import 'package:flutter/material.dart';

class DentistMap extends StatefulWidget {
  @override
  _DentistMapState createState() => _DentistMapState();
}

class _DentistMapState extends State<DentistMap> {
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
        title: Text('Nearby Dentists'),
      ),
      body: Stack(
        children: [
          DentistMapWidget(),
          // DentistCard(),
        ],
      ),
    );
  }
}
