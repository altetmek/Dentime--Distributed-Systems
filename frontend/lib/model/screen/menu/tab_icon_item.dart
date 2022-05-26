import 'package:dentime/model/screen/menu/screen_index.dart';
import 'package:flutter/widgets.dart';

class TabIconItem {
  TabIconItem({
    this.icon,
    this.imagePath = '',
    this.index,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });
  IconData icon;
  String imagePath;
  String selectedImagePath;
  bool isSelected;
  ScreenIndex index;
  AnimationController animationController;
}
