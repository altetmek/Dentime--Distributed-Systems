import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuIcon extends StatelessWidget {
  MenuIcon({
    this.colour = DentimeApplicationTheme.primaryColor,
    this.callback,
  });

  final Color colour;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/icons/logoIcon.png'),
      onPressed: Provider.of<NavigationManager>(context)
          .drawerKey
          .currentState
          .openDrawer,
    );
  }
}
