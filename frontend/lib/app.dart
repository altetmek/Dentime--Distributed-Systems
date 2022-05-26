import 'package:dentime/ui/screen/onboarding/onboarding.dart';
import 'package:dentime/ui/widget/alert/overloaded/overloaded.dart';
import 'package:dentime/ui/widget/flavour_banner.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dentime extends StatefulWidget {
  @override
  _DentimeState createState() => _DentimeState();
}

class _DentimeState extends State<Dentime> {
  bool onBoardingSeen = true;

  Future checkOnBoardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _onBoardingSeen = (prefs.getBool('onBoardingSeen') ?? false);

    if (!_onBoardingSeen) {
      await prefs.setBool('onBoardingSeen', true);
      setState(() {
        onBoardingSeen = false;
      });
    }
  }

  _closeOnboarding() {
    setState(() {
      onBoardingSeen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkOnBoardingSeen();
    return FlavourBanner(
      child: SafeArea(
        // child: !onBoardingSeen ? Onboarding() : MainScreen(),
        child: !onBoardingSeen
            ? Onboarding(closeOnboarding: _closeOnboarding)
            : Overloaded(),
      ),
    );
  }
}
