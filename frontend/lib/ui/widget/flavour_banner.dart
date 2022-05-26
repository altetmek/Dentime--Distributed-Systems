import 'package:dentime/util/env/flavour_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlavourBanner extends StatelessWidget {
  final Widget child;

  const FlavourBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.instance.isProduction()) return child;
    return Stack(
      children: [
        child,
        _buildBanner(context),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: FlavorConfig.instance.name,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topEnd,
          color: FlavorConfig.instance.color,
        ),
      ),
    );
  }
}
