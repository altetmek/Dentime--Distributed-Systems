import 'dart:math' as math;
import 'package:dentime/model/screen/menu/screen_index.dart';
import 'package:dentime/model/screen/menu/tab_icon_item.dart';
import 'package:dentime/ui/theme/dentime.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar(
      {Key key, this.tabIconsList, this.changeIndex, this.onCenterButtonClick})
      : super(key: key);

  final Function(ScreenIndex index) changeIndex;
  final Function onCenterButtonClick;
  final List<TabIconItem> tabIconsList;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  @override
  void dispose() {
    super.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  @override
  void initState() {
    super.initState();
    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Log.i('_NavigationBar is building');
    final Size size = MediaQuery.of(context).size;
    final double height = 62;
    final double width = size.width > DentimeApplicationTheme.navBarMaxWidth
        ? DentimeApplicationTheme.navBarMaxWidth
        : size.width;
    return _keyboardState
        ? Container()
        : Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: height,
                width: size.width,
                child: Center(
                  child: Container(
                    height: height,
                    width: width,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(
                                  width,
                                  height,
                                ),
                                painter: BNBCustomPainter(),
                              ),
                              Container(
                                width: width,
                                height: height,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TabIcon(
                                        tabIconData: widget.tabIconsList[0],
                                        onTap: () {
                                          widget.changeIndex(
                                              widget.tabIconsList[0].index);
                                        }),
                                    TabIcon(
                                        tabIconData: widget.tabIconsList[1],
                                        onTap: () {
                                          widget.changeIndex(
                                              widget.tabIconsList[1].index);
                                        }),
                                    Container(width: width * 0.20),
                                    TabIcon(
                                        tabIconData: widget.tabIconsList[2],
                                        onTap: () {
                                          widget.changeIndex(
                                              widget.tabIconsList[2].index);
                                        }),
                                    TabIcon(
                                        tabIconData: widget.tabIconsList[3],
                                        onTap: () {
                                          widget.changeIndex(
                                              widget.tabIconsList[3].index);
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: (height / 2)),
                child: FloatingActionButton(
                  backgroundColor: DentimeApplicationTheme.nearlyWhite,
                  // elevation: 18,
                  child: Icon(
                    Icons.expand_less,
                    color: DentimeApplicationTheme.bottomBar,
                    size: 32,
                  ),
                  onPressed: widget.onCenterButtonClick,
                ),
              ),
            ],
          );
  }
}

class TabIcon extends StatelessWidget {
  const TabIcon({Key key, this.tabIconData, this.onTap}) : super(key: key);

  final TabIconItem tabIconData;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    Log.i('_TabIcon is building');
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Center(
          child: tabIconData.icon != null
              ? Container(
                  child: Icon(tabIconData.icon,
                      color: tabIconData.isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5)),
                )
              : SvgPicture.asset(
                  tabIconData.selectedImagePath,
                  color: tabIconData.isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  BNBCustomPainter({this.radius = 38.0});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = DentimeApplicationTheme.bottomBar
      ..style = PaintingStyle.fill;
    Path path = getPath(size);

    canvas.drawPath(path, paint);
  }

  Path getPath(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}
