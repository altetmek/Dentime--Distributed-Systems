library time_slider;

import 'dart:ui';

import 'package:flutter/material.dart';

class RadioModel {
  bool isSelected;
  String hourText;
  RadioModel(this.isSelected, this.hourText);
}

class TimeSlider extends StatefulWidget {
  final List<RadioModel> hoursList;

  final Color color;
  final Color selectedColor;
  final Color textColor;
  final Color selectedTextColor;
  final double height;
  final double width;
  final Function onPressed;
  final double separation;

  const TimeSlider(
      {Key key,
      this.hoursList,
      this.color,
      this.selectedColor,
      this.height,
      this.width,
      this.onPressed,
      this.textColor,
      this.selectedTextColor,
      this.separation});

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount: widget.hoursList.length,
      itemBuilder: (context, index) {
        return Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  widget.hoursList
                      .forEach((element) => element.isSelected = false);
                  widget.hoursList[index].isSelected = true;
                });
                widget.onPressed(widget.hoursList[index].hourText);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  width: widget.width,
                  height: widget.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: (widget.hoursList[index].isSelected == true)
                        ? widget.color
                        : widget.selectedColor,
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                  child: Text(
                    widget.hoursList[index].hourText,
                    style: TextStyle(
                      color: (widget.hoursList[index].isSelected == true)
                          ? widget.textColor
                          : widget.selectedTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
            SizedBox(
              width: widget.separation,
            )
          ],
        );
      },
    );
  }
}
