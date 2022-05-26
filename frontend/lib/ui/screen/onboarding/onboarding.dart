import 'package:dentime/model/onboard_slider/slider.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/ui/widget/onboard_slider/onboard_slideritem.dart';
import 'package:dentime/ui/widget/onboard_slider/slide_indicator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Onboarding extends StatefulWidget {
  Onboarding({this.closeOnboarding});

  final Function closeOnboarding;
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DentimeApplicationTheme.onBoarding,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            onPageChanged: _onPageChanged,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: slideList.length,
            itemBuilder: (ctx, i) => OnBoardSliderItem(
              index: i,
              closeOnboarding: widget.closeOnboarding,
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.bottomCenter,
                margin: const EdgeInsets.only(bottom: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < slideList.length; i++)
                      if (i == _currentPage)
                        SlideIndicator(true)
                      else
                        SlideIndicator(false)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
