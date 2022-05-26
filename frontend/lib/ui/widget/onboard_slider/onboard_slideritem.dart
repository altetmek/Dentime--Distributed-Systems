import 'package:dentime/model/onboard_slider/slider.dart';
import 'package:flutter/material.dart';
import 'package:dentime/ui/theme/dentime.dart';

class OnBoardSliderItem extends StatelessWidget {
  final int index;
  final Function closeOnboarding;

  OnBoardSliderItem({this.index, this.closeOnboarding});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage(slideList[index].imageUrl),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 200.0,
              child: Text(slideList[index].title,
                  textAlign: TextAlign.center,
                  style: DentimeApplicationTheme.bodyText1),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  child: Text(
                    slideList[index].description,
                    textAlign: TextAlign.center,
                    style: DentimeApplicationTheme.bodyText2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                      color: Colors.grey,
                      child: TextButton(
                          onPressed: () {
                            closeOnboarding();
                          },
                          child: Text('Start Booking!',
                              style: TextStyle(color: Colors.white)))),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
