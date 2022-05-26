import 'package:dentime/ui/theme/dentime.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: DentimeApplicationTheme.nearlyBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Drawer'),
          FlatButton(
            onPressed: () {
              showAboutDialog(context: context);
            },
            child: Text('About'),
          ),
        ],
      ),
    );
  }
}
