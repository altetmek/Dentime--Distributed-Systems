import 'package:dentime/manager/navigation/navigation_manager.dart';
import 'package:dentime/ui/screen/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Overloaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isOverloaded =
        Provider.of<NavigationManager>(context).isOverloaded;
    return Stack(
      children: [
        MainScreen(),
        isOverloaded
            ? Center(
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.red[900],
                  child: Center(
                    child: Text(
                      'System Overloaded\nplease try again later',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
